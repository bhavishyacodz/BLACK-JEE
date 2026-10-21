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
