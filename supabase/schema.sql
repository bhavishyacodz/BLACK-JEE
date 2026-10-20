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

create table if not exists public.attempt_submissions (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.daily_questions(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 60),
  elapsed_seconds integer not null check (elapsed_seconds >= 0 and elapsed_seconds <= 604800),
  selected_option text,
  photo_path text,
  is_reviewed boolean not null default false,
  is_public boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.daily_questions enable row level security;
alter table public.attempt_submissions enable row level security;

revoke all on public.daily_questions from anon, authenticated;
revoke all on public.attempt_submissions from anon, authenticated;
grant select on public.daily_questions to anon, authenticated;
grant insert, update, delete on public.daily_questions to authenticated;
grant select, insert on public.attempt_submissions to anon, authenticated;
grant update on public.attempt_submissions to authenticated;
grant select, insert on table storage.objects to anon, authenticated;

drop policy if exists "Live questions are public; admins see all" on public.daily_questions;
create policy "Live questions are public; admins see all"
on public.daily_questions for select to anon, authenticated
using ((is_live = true and question_date <= (now() at time zone 'Asia/Kolkata')::date)
  or (auth.jwt()->'app_metadata'->>'role' = 'admin'));

drop policy if exists "Admins can insert questions" on public.daily_questions;
create policy "Admins can insert questions"
on public.daily_questions for insert to authenticated
with check (auth.jwt()->'app_metadata'->>'role' = 'admin');

drop policy if exists "Admins can update questions" on public.daily_questions;
create policy "Admins can update questions"
on public.daily_questions for update to authenticated
using (auth.jwt()->'app_metadata'->>'role' = 'admin')
with check (auth.jwt()->'app_metadata'->>'role' = 'admin');

drop policy if exists "Admins can delete questions" on public.daily_questions;
create policy "Admins can delete questions"
on public.daily_questions for delete to authenticated
using (auth.jwt()->'app_metadata'->>'role' = 'admin');

drop policy if exists "Visitors can submit attempts for review" on public.attempt_submissions;
create policy "Visitors can submit attempts for review"
on public.attempt_submissions for insert to anon, authenticated
with check (
  is_public = false and is_reviewed = false
  and char_length(trim(display_name)) between 1 and 60
  and exists (
    select 1 from public.daily_questions q
    where q.id = attempt_submissions.question_id and q.is_live = true
  )
);

drop policy if exists "Public sees approved attempts; admins see all" on public.attempt_submissions;
create policy "Public sees approved attempts; admins see all"
on public.attempt_submissions for select to anon, authenticated
using (is_public = true or auth.jwt()->'app_metadata'->>'role' = 'admin');

drop policy if exists "Admins can review attempts" on public.attempt_submissions;
create policy "Admins can review attempts"
on public.attempt_submissions for update to authenticated
using (auth.jwt()->'app_metadata'->>'role' = 'admin')
with check (auth.jwt()->'app_metadata'->>'role' = 'admin');

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
    auth.jwt()->'app_metadata'->>'role' = 'admin'
    or exists (
      select 1 from public.attempt_submissions s
      where s.photo_path = storage.objects.name and s.is_public = true
    )
  )
);

-- Seed a sample challenge for today's India date when this setup is run.
-- If a row already exists for today, it is left unchanged.
insert into public.daily_questions
  (question_date, title, statement, tags, difficulty, options, solution, solution_published, is_live)
values
  (
    (now() at time zone 'Asia/Kolkata')::date,
    'The Grand Unification Problem',
    'A uniform conducting rod of mass m = 1 kg and length l = 1 m slides down two smooth vertical conducting rails. A uniform magnetic field B = 2 T is perpendicular to the plane of the rails. The rails are connected to an ideal capacitor C = 0.5 F. The rod is released from rest and falls h = 15 m; at that point, a switch disconnects the capacitor. All stored electrical energy is converted into N = 1.0 × 10^20 identical photons. The beam passes through an equilateral glass prism of refractive index μ = √2 at minimum deviation and then strikes a metal of work function Φ = 2.25 eV. Find δ_m × V_s. Take g = 10 m/s² and 1 eV = 1.6 × 10^-19 J.',
    array['Physics','EMI','Mechanics','Ray Optics','Modern Physics'],
    'Extreme',
    '["A) 60","B) 90","C) 120","D) 150"]'::jsonb,
    '1. The motional emf is V = Blv. With C dV/dt = CBl a, the induced current is i = CBl a. The upward magnetic force is iBl = CB²l²a. Thus mg = (m + CB²l²)a, so a = 10/3 m/s². 2. From v² = 2ah with h = 15 m, v = 10 m/s. Therefore V = Blv = 20 V and capacitor energy U = ½CV² = 100 J. 3. Each photon has energy U/N = 10^-18 J = 6.25 eV. 4. For A = 60° and μ = √2, the minimum-deviation formula gives δ_m = 30°. 5. K_max = 6.25 − 2.25 = 4.00 eV, so V_s = 4.00 V. Product = 30 × 4 = 120. Correct option: C.',
    false,
    true
  )
on conflict (question_date) do nothing;

-- Verification after running:
-- select question_date, title, is_live from public.daily_questions order by question_date desc limit 3;
-- select count(*) as submissions from public.attempt_submissions;
