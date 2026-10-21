-- BLACK JEE daily challenge scoring, delayed results, and archive.
-- Challenge date is the closing date: opens at 12:00 IST on the previous day,
-- closes at 12:00 IST on this date, and official results release at 18:00 IST.

create schema if not exists private;
alter table public.daily_questions
  add column if not exists correct_answer text,
  add column if not exists starts_at timestamptz,
  add column if not exists ends_at timestamptz;
alter table public.attempt_submissions
  add column if not exists is_correct boolean,
  add column if not exists score integer not null default 0,
  add column if not exists public_name_consent boolean not null default false,
  add column if not exists submitted_at timestamptz not null default now();

update public.daily_questions
set starts_at=((question_date-1)::timestamp+time '12:00') at time zone 'Asia/Kolkata',
    ends_at=(question_date::timestamp+time '12:00') at time zone 'Asia/Kolkata'
where starts_at is null or ends_at is null;

create or replace function private.set_daily_question_window()
returns trigger language plpgsql set search_path=''
as $$
begin
 new.starts_at:=((new.question_date-1)::timestamp+time '12:00') at time zone 'Asia/Kolkata';
 new.ends_at:=(new.question_date::timestamp+time '12:00') at time zone 'Asia/Kolkata';
 return new;
end; $$;
drop trigger if exists set_daily_question_window on public.daily_questions;
create trigger set_daily_question_window before insert or update of question_date on public.daily_questions
for each row execute function private.set_daily_question_window();

create table if not exists private.challenge_attempt_sessions(
 question_id uuid not null references public.daily_questions(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 started_at timestamptz not null default now(),
 primary key(question_id,user_id)
);
alter table private.challenge_attempt_sessions enable row level security;
revoke all on schema private from public,anon,authenticated;
revoke all on private.challenge_attempt_sessions from public,anon,authenticated;

-- Keep answer keys and worked solutions out of normal Data API reads.
revoke select on public.daily_questions from anon,authenticated;
grant select(id,question_date,title,statement,tags,difficulty,options,solution_published,is_live,created_at,starts_at,ends_at)
 on public.daily_questions to anon,authenticated;
grant insert,update,delete on public.daily_questions to authenticated;
grant update(question_date,title,statement,tags,difficulty,options,solution,solution_published,is_live,correct_answer,starts_at,ends_at)
 on public.daily_questions to authenticated;

drop policy if exists "Live questions are public; admins see all" on public.daily_questions;
drop policy if exists "Live and archived questions are public; admins see all" on public.daily_questions;
create policy "Live and archived questions are public; admins see all"
on public.daily_questions for select to anon,authenticated
using ((is_live=true and starts_at<=now()) or (select auth.jwt())->'app_metadata'->>'role'='admin');

revoke insert on public.attempt_submissions from anon,authenticated;
drop policy if exists "Signed-in users can submit their own attempt once" on public.attempt_submissions;
drop policy if exists "Visitors can submit attempts for review" on public.attempt_submissions;

create or replace function public.start_challenge_attempt(p_question_id uuid)
returns jsonb language plpgsql security definer set search_path=''
as $$
declare v_uid uuid:=auth.uid(); v_question public.daily_questions%rowtype; v_started timestamptz;
begin
 if v_uid is null then raise exception 'Sign in to start a challenge.' using errcode='28000'; end if;
 select * into v_question from public.daily_questions q where q.id=p_question_id and q.is_live=true;
 if not found then raise exception 'Challenge not found.'; end if;
 if now()<v_question.starts_at or now()>=v_question.ends_at then raise exception 'This challenge is not currently open.'; end if;
 if exists(select 1 from public.attempt_submissions s where s.user_id=v_uid and s.question_id=p_question_id) then raise exception 'You have already submitted this challenge.'; end if;
 insert into private.challenge_attempt_sessions(question_id,user_id) values(p_question_id,v_uid) on conflict(question_id,user_id) do nothing;
 select started_at into v_started from private.challenge_attempt_sessions where question_id=p_question_id and user_id=v_uid;
 return jsonb_build_object('started_at',v_started);
end; $$;

create or replace function public.submit_challenge_answer(
 p_question_id uuid,p_selected_option text,p_display_name text,p_public_name_consent boolean default false
) returns jsonb language plpgsql security definer set search_path=''
as $$
declare v_uid uuid:=auth.uid(); v_question public.daily_questions%rowtype; v_started timestamptz;
 v_elapsed integer; v_correct boolean:=false; v_submission_id uuid; v_name text;
begin
 if v_uid is null then raise exception 'Sign in to submit your answer.' using errcode='28000'; end if;
 v_name:=left(trim(coalesce(p_display_name,'')),60);
 if char_length(v_name)<1 then raise exception 'Enter a display name.'; end if;
 if p_selected_option is null or char_length(trim(p_selected_option))=0 then raise exception 'Choose an option first.'; end if;
 select * into v_question from public.daily_questions q where q.id=p_question_id and q.is_live=true;
 if not found then raise exception 'Challenge not found.'; end if;
 if now()<v_question.starts_at or now()>=v_question.ends_at then raise exception 'The challenge is closed.'; end if;
 select started_at into v_started from private.challenge_attempt_sessions where question_id=p_question_id and user_id=v_uid;
 if v_started is null then raise exception 'Start the timer before submitting.'; end if;
 if exists(select 1 from public.attempt_submissions s where s.user_id=v_uid and s.question_id=p_question_id) then raise exception 'You have already submitted this challenge.'; end if;
 v_elapsed:=greatest(0,least(604800,floor(extract(epoch from(now()-v_started)))::integer));
 select upper(chr(65+opt.ordinality-1))=upper(left(trim(coalesce(v_question.correct_answer,'')),1))
 into v_correct
 from jsonb_array_elements_text(v_question.options) with ordinality as opt(value,ordinality)
 where trim(opt.value)=trim(p_selected_option) limit 1;
 v_correct:=coalesce(v_correct,false);
 insert into public.attempt_submissions
 (question_id,question_link_id,user_id,display_name,elapsed_seconds,selected_option,photo_path,is_reviewed,is_public,is_correct,score,public_name_consent,submitted_at)
 values(p_question_id,null,v_uid,v_name,v_elapsed,p_selected_option,null,false,false,v_correct,case when v_correct then 100 else 0 end,coalesce(p_public_name_consent,false),now())
 returning id into v_submission_id;
 return jsonb_build_object('submission_id',v_submission_id,'is_correct',v_correct,'elapsed_seconds',v_elapsed,
 'message',case when v_correct then 'Correct answer.' else 'Not quite. The official answer is revealed when results are released.' end);
end; $$;

create or replace function public.get_challenge_result(p_question_id uuid)
returns jsonb language plpgsql stable security definer set search_path=''
as $$
declare v_question public.daily_questions%rowtype; v_winners jsonb; v_release_at timestamptz;
begin
 select * into v_question from public.daily_questions q where q.id=p_question_id;
 if not found then return jsonb_build_object('released',false,'message','Challenge not found.'); end if;
 v_release_at:=v_question.ends_at+interval '6 hours';
 if now()<v_release_at then return jsonb_build_object('released',false,'ends_at',v_question.ends_at,'results_at',v_release_at); end if;
 select coalesce(jsonb_agg(to_jsonb(w)),'[]'::jsonb) into v_winners from (
  select s.display_name,s.score,s.elapsed_seconds,s.submitted_at,row_number() over(order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc) as place
  from public.attempt_submissions s where s.question_id=p_question_id and s.is_correct is true and s.is_public is true and s.public_name_consent is true
  order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc limit 3
 ) w;
 return jsonb_build_object('released',true,'question_id',v_question.id,'question_date',v_question.question_date,'title',v_question.title,
 'correct_answer',v_question.correct_answer,'solution',case when v_question.solution_published then v_question.solution else null end,'winners',v_winners);
end; $$;

create or replace function public.get_challenge_archive()
returns jsonb language sql stable security definer set search_path=''
as $$
 select coalesce(jsonb_agg(jsonb_build_object(
  'id',q.id,'question_date',q.question_date,'title',q.title,'statement',q.statement,'options',q.options,
  'released',(now()>=q.ends_at+interval '6 hours'),
  'correct_answer',case when now()>=q.ends_at+interval '6 hours' then q.correct_answer else null end,
  'solution',case when now()>=q.ends_at+interval '6 hours' and q.solution_published then q.solution else null end,
  'winners',case when now()>=q.ends_at+interval '6 hours' then (
   select coalesce(jsonb_agg(to_jsonb(w)),'[]'::jsonb) from (
    select s.display_name,s.score,s.elapsed_seconds,row_number() over(order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc) as place
    from public.attempt_submissions s where s.question_id=q.id and s.is_correct is true and s.is_public is true and s.public_name_consent is true
    order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc limit 3
   ) w
  ) else '[]'::jsonb end
 ) order by q.question_date desc),'[]'::jsonb)
 from public.daily_questions q where q.ends_at+interval '6 hours'<=now();
$$;

revoke all on function public.start_challenge_attempt(uuid) from public,anon;
revoke all on function public.submit_challenge_answer(uuid,text,text,boolean) from public,anon;
revoke all on function public.get_challenge_result(uuid) from public;
revoke all on function public.get_challenge_archive() from public;
grant execute on function public.start_challenge_attempt(uuid) to authenticated;
grant execute on function public.submit_challenge_answer(uuid,text,text,boolean) to authenticated;
grant execute on function public.get_challenge_result(uuid) to anon,authenticated;
grant execute on function public.get_challenge_archive() to anon,authenticated;
