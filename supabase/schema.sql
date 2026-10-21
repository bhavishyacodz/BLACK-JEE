-- BLACK JEE database setup
-- Run once in Supabase Dashboard > SQL Editor.
-- Uses a private Storage bucket so pending handwritten solutions are not public by default.

create extension if not exists pgcrypto;

create table if not exists public.daily_questions (
  id uuid primary key default gen_random_uuid(),
  question_date date not null unique,
  title text not null,
  statement text not null,
  tags text[] not null default '{}',
  difficulty text not null default 'JEE Advanced',
  options jsonb not null default '[]'::jsonb,
  solution text,
  correct_answer text,
  starts_at timestamptz,
  ends_at timestamptz,
  solution_published boolean not null default false,
  is_live boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.active_question_links (
  id uuid primary key default gen_random_uuid(),
  title text not null default 'Today''s question',
  url text not null,
  is_live boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists public.attempt_submissions (
  id uuid primary key default gen_random_uuid(),
  question_id uuid references public.daily_questions(id) on delete cascade,
  question_link_id uuid references public.active_question_links(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 60),
  elapsed_seconds integer not null check (elapsed_seconds >= 0 and elapsed_seconds <= 604800),
  selected_option text,
  photo_path text,
  is_reviewed boolean not null default false,
  is_public boolean not null default false,
  is_correct boolean,
  score integer not null default 0,
  public_name_consent boolean not null default false,
  submitted_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  constraint attempt_submissions_exactly_one_question_target check (
    (question_id is not null and question_link_id is null)
    or (question_id is null and question_link_id is not null)
  )
);

alter table public.daily_questions enable row level security;
alter table public.attempt_submissions enable row level security;

-- Supports question joins, per-user history, and admin review queries.
create index if not exists attempt_submissions_question_id_idx on public.attempt_submissions(question_id);
create index if not exists attempt_submissions_question_link_id_idx on public.attempt_submissions(question_link_id);
create unique index if not exists attempt_submissions_one_per_user_question_idx
  on public.attempt_submissions(user_id, question_id)
  where user_id is not null and question_id is not null;
create unique index if not exists attempt_submissions_one_per_user_link_idx
  on public.attempt_submissions(user_id, question_link_id)
  where user_id is not null and question_link_id is not null;

revoke all on public.daily_questions from anon, authenticated;
revoke all on public.attempt_submissions from anon, authenticated;
grant select (id, question_date, title, statement, tags, difficulty, options, solution_published, is_live, created_at) on public.daily_questions to anon, authenticated;
grant insert, update, delete on public.daily_questions to authenticated;
grant select on public.attempt_submissions to anon, authenticated;
grant insert on public.attempt_submissions to authenticated;
grant update (is_public, is_reviewed, photo_path) on public.attempt_submissions to authenticated;
grant select, insert on table storage.objects to anon, authenticated;

drop policy if exists "Live questions are public; admins see all" on public.daily_questions;
create policy "Live questions are public; admins see all"
on public.daily_questions for select to anon, authenticated
using ((is_live = true and question_date <= (
    (now() at time zone 'Asia/Kolkata')::date
    + case when extract(hour from (now() at time zone 'Asia/Kolkata')) >= 12 then 1 else 0 end
  ))
  or ((select auth.jwt())->'app_metadata'->>'role' = 'admin'));

drop policy if exists "Admins can insert questions" on public.daily_questions;
create policy "Admins can insert questions"
on public.daily_questions for insert to authenticated
with check ((select auth.jwt())->'app_metadata'->>'role' = 'admin');

drop policy if exists "Admins can update questions" on public.daily_questions;
create policy "Admins can update questions"
on public.daily_questions for update to authenticated
using ((select auth.jwt())->'app_metadata'->>'role' = 'admin')
with check ((select auth.jwt())->'app_metadata'->>'role' = 'admin');

drop policy if exists "Admins can delete questions" on public.daily_questions;
create policy "Admins can delete questions"
on public.daily_questions for delete to authenticated
using ((select auth.jwt())->'app_metadata'->>'role' = 'admin');

drop policy if exists "Visitors can submit attempts for review" on public.attempt_submissions;
drop policy if exists "Signed-in users can submit their own attempt once" on public.attempt_submissions;
create policy "Signed-in users can submit their own attempt once"
on public.attempt_submissions for insert to authenticated
with check (
  user_id = (select auth.uid())
  and is_public = false and is_reviewed = false
  and char_length(trim(display_name)) between 1 and 60
  and (
    (question_id is not null and question_link_id is null and exists (
      select 1 from public.daily_questions q
      where q.id = attempt_submissions.question_id and q.is_live = true
    ))
    or
    (question_id is null and question_link_id is not null and exists (
      select 1 from public.active_question_links l
      where l.id = attempt_submissions.question_link_id and l.is_live = true
    ))
  )
);

drop policy if exists "Public sees approved attempts; admins see all" on public.attempt_submissions;
drop policy if exists "Users see their own attempts; public sees approved; admins see all" on public.attempt_submissions;
create policy "Users see their own attempts; public sees approved; admins see all"
on public.attempt_submissions for select to anon, authenticated
using (
  is_public = true
  or user_id = (select auth.uid())
  or (select auth.jwt())->'app_metadata'->>'role' = 'admin'
);

drop policy if exists "Admins can review attempts" on public.attempt_submissions;
create policy "Admins can review attempts"
on public.attempt_submissions for update to authenticated
using ((select auth.jwt())->'app_metadata'->>'role' = 'admin')
with check ((select auth.jwt())->'app_metadata'->>'role' = 'admin');

drop policy if exists "Users can attach photo to own pending attempts" on public.attempt_submissions;
create policy "Users can attach photo to own pending attempts" on public.attempt_submissions for update to authenticated
using (user_id = (select auth.uid()) and is_public = false and is_reviewed = false)
with check (user_id = (select auth.uid()) and is_public = false and is_reviewed = false);

-- Private storage: unapproved photo URLs are not publicly accessible.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('attempt-photos', 'attempt-photos', false, 6291456, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update
set public = false, file_size_limit = 6291456, allowed_mime_types = array['image/jpeg','image/png','image/webp'];

drop policy if exists "Visitors can upload attempt photos" on storage.objects;
create policy "Visitors can upload attempt photos"
on storage.objects for insert to anon, authenticated
with check (bucket_id = 'attempt-photos');

drop policy if exists "Approved photos and admins can view attempt photos" on storage.objects;
create policy "Approved photos and admins can view attempt photos"
on storage.objects for select to anon, authenticated
using (
  bucket_id = 'attempt-photos'
  and (
    (select auth.jwt())->'app_metadata'->>'role' = 'admin'
    or exists (
      select 1 from public.attempt_submissions s
      where s.photo_path = storage.objects.name and s.is_public = true
    )
  )
);

-- Return the official solution only after 6:00 PM IST, and only when the owner explicitly marked it for publication.
-- SECURITY DEFINER is intentional: public clients must not have direct SELECT access to solution.
-- Keep this function narrowly scoped and release-gated.
create or replace function public.get_released_solution(p_question_date date)
returns text
language sql
stable
security definer
set search_path = ''
as $function$
  select q.solution
  from public.daily_questions as q
  where q.question_date = p_question_date
    and q.is_live = true
    and q.solution_published = true
    and p_question_date <= (now() at time zone 'Asia/Kolkata')::date
    and (now() at time zone 'Asia/Kolkata') >= (p_question_date::timestamp + interval '18 hours')
  limit 1;
$function$;
revoke all on function public.get_released_solution(date) from public, anon, authenticated;
grant execute on function public.get_released_solution(date) to service_role;

-- Seed a sample challenge for today's India date when this setup is run.
-- If a row already exists for today, it is left unchanged.
insert into public.daily_questions
  (question_date, title, statement, tags, difficulty, options, solution, solution_published, is_live)
values
  (
    ((now() at time zone 'Asia/Kolkata')::date
      + case when extract(hour from (now() at time zone 'Asia/Kolkata')) >= 12 then 1 else 0 end),
    'SHM: Speed at Half Amplitude',
    'A particle performs simple harmonic motion with amplitude A and angular frequency ω. What is its speed when its displacement from the mean position is A/2?',
    array['Physics','SHM','JEE Main'],
    'JEE Main',
    '["A) ωA/2","B) √3ωA/2","C) ωA","D) 2ωA"]'::jsonb,
    'For simple harmonic motion, v² = ω²(A² − x²). At x = A/2, v = ω√(A² − A²/4) = (√3/2)ωA. Correct option: B.',
    false,
    true
  )
on conflict (question_date) do nothing;

-- Verification after running:
-- select question_date, title, is_live from public.daily_questions order by question_date desc limit 3;
-- select count(*) as submissions from public.attempt_submissions;


-- Launch readiness additions: Golden Sunday, secure result reveal, and archive controls.
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


-- Security audit hardening (also recorded in migration 20261021000800_restrict_truncate_and_photo_paths.sql)
-- BLACK JEE security audit: remove unnecessary table capabilities,
-- combine update policies, and prevent cross-account photo-path references.
begin;

revoke truncate, trigger, references
on table public.active_question_links, public.daily_questions, public.attempt_submissions
from anon, authenticated;

drop policy if exists "Admins can review attempts" on public.attempt_submissions;
drop policy if exists "Users can attach photo to own pending attempts" on public.attempt_submissions;
drop policy if exists "Admins review or users attach own photo" on public.attempt_submissions;

create policy "Admins review or users attach own photo"
on public.attempt_submissions
for update
to authenticated
using (
  ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
  or (
    user_id = (select auth.uid())
    and is_public = false
    and is_reviewed = false
  )
)
with check (
  ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
  or (
    user_id = (select auth.uid())
    and is_public = false
    and is_reviewed = false
    and (
      photo_path is null
      or left(photo_path, length(((select auth.uid())::text) || '/'))
         = ((select auth.uid())::text || '/')
    )
  )
);

commit;
