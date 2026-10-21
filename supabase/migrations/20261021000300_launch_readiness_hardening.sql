-- Golden Sunday scheduling, delayed result publication, and public archive hardening.
alter table public.daily_questions
  add column if not exists challenge_type text not null default 'daily';
alter table public.daily_questions
  drop constraint if exists daily_questions_challenge_type_check;
alter table public.daily_questions
  add constraint daily_questions_challenge_type_check
  check (challenge_type in ('daily','golden_sunday'));
alter table public.daily_questions
  add column if not exists show_in_archive boolean not null default true;
alter table public.daily_questions alter column solution_published set default true;
grant select (challenge_type) on public.daily_questions to anon, authenticated;

create or replace function public.prepare_daily_challenge_schedule()
returns trigger language plpgsql set search_path = ''
as $$
declare v_day integer; v_date date;
begin
  v_date := new.question_date;
  v_day := extract(dow from v_date)::integer;
  if v_day = 0 then
    new.challenge_type := 'golden_sunday';
    if new.title is null or btrim(new.title) = '' then
      new.title := 'THE SOVEREIGN GAUNTLET — GOLDEN SUNDAY';
    elsif new.title not ilike 'THE SOVEREIGN GAUNTLET%' then
      new.title := 'THE SOVEREIGN GAUNTLET — GOLDEN SUNDAY: ' || new.title;
    end if;
  else
    new.challenge_type := 'daily';
  end if;
  -- A challenge dated D opens at noon IST on D-1 and closes at noon IST on D.
  new.starts_at := make_timestamptz(extract(year from (v_date - 1))::int,extract(month from (v_date - 1))::int,extract(day from (v_date - 1))::int,12,0,0,'Asia/Kolkata');
  new.ends_at := make_timestamptz(extract(year from v_date)::int,extract(month from v_date)::int,extract(day from v_date)::int,12,0,0,'Asia/Kolkata');
  if new.is_live then new.show_in_archive := true; end if;
  return new;
end;
$$;
drop trigger if exists prepare_daily_challenge_schedule on public.daily_questions;
create trigger prepare_daily_challenge_schedule
before insert or update of question_date, title, is_live on public.daily_questions
for each row execute function public.prepare_daily_challenge_schedule();

update public.daily_questions
set show_in_archive = false, is_live = false
where question_date in (date '2026-10-21', date '2026-10-22')
  and title in ('Xh','Hhhhhii8j888');

create or replace function public.get_challenge_archive()
returns jsonb language sql stable security definer set search_path = ''
as $$
 select coalesce(jsonb_agg(jsonb_build_object(
  'id',q.id,'question_date',q.question_date,'title',q.title,'challenge_type',q.challenge_type,
  'statement',q.statement,'options',q.options,
  'released',(now()>=q.ends_at+interval '6 hours'),
  'correct_answer',case when now()>=q.ends_at+interval '6 hours' then q.correct_answer else null end,
  'solution',case when now()>=q.ends_at+interval '6 hours' and q.solution_published then q.solution else null end,
  'winners',case when now()>=q.ends_at+interval '6 hours' then (
    select coalesce(jsonb_agg(to_jsonb(w)),'[]'::jsonb) from (
      select s.display_name,s.score,s.elapsed_seconds,
        row_number() over(order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc) as place
      from public.attempt_submissions s
      where s.question_id=q.id and s.is_correct is true and s.is_public is true and s.public_name_consent is true
      order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc limit 3
    ) w
  ) else '[]'::jsonb end
 ) order by q.question_date desc),'[]'::jsonb)
 from public.daily_questions q
 where q.show_in_archive = true and q.ends_at+interval '6 hours'<=now();
$$;

create or replace function public.get_challenge_result(p_question_id uuid)
returns jsonb language plpgsql stable security definer set search_path = ''
as $$
declare v_question public.daily_questions%rowtype; v_winners jsonb; v_release_at timestamptz;
begin
 select * into v_question from public.daily_questions q where q.id=p_question_id;
 if not found then return jsonb_build_object('released',false,'message','Challenge not found.'); end if;
 v_release_at:=v_question.ends_at+interval '6 hours';
 if now()<v_release_at then return jsonb_build_object('released',false,'ends_at',v_question.ends_at,'results_at',v_release_at); end if;
 select coalesce(jsonb_agg(to_jsonb(w)),'[]'::jsonb) into v_winners
 from (select s.display_name,s.score,s.elapsed_seconds,s.submitted_at,
 row_number() over(order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc) as place
 from public.attempt_submissions s where s.question_id=p_question_id and s.is_correct is true
 and s.is_public is true and s.public_name_consent is true
 order by s.score desc,s.elapsed_seconds asc,s.submitted_at asc limit 3) w;
 return jsonb_build_object('released',true,'question_id',v_question.id,'question_date',v_question.question_date,
 'title',v_question.title,'challenge_type',v_question.challenge_type,'correct_answer',v_question.correct_answer,
 'solution',case when v_question.solution_published then v_question.solution else null end,'winners',v_winners);
end;
$$;
revoke all on function public.get_challenge_result(uuid) from public, anon, authenticated;
revoke all on function public.start_challenge_attempt(uuid) from public, anon;
grant execute on function public.start_challenge_attempt(uuid) to authenticated;
revoke all on function public.submit_challenge_answer(uuid,text,text,boolean) from public, anon;
grant execute on function public.submit_challenge_answer(uuid,text,text,boolean) to authenticated;
revoke all on function public.get_challenge_archive() from public;
grant execute on function public.get_challenge_archive() to anon, authenticated;
