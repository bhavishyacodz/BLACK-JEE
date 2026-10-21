-- BLACK JEE: one attempt per authenticated user per question.
-- Safe to apply more than once; unique indexes are the final concurrency-safe guard.

alter table public.attempt_submissions
  alter column user_id set not null;

create unique index if not exists attempt_submissions_one_per_user_question_idx
  on public.attempt_submissions (user_id, question_id)
  where user_id is not null and question_id is not null;

create unique index if not exists attempt_submissions_one_per_user_link_idx
  on public.attempt_submissions (user_id, question_link_id)
  where user_id is not null and question_link_id is not null;

alter table public.attempt_submissions
  drop constraint if exists attempt_submissions_exactly_one_question_target;
alter table public.attempt_submissions
  add constraint attempt_submissions_exactly_one_question_target
  check (
    (question_id is not null and question_link_id is null)
    or (question_id is null and question_link_id is not null)
  );

drop policy if exists "Visitors can submit attempts for review" on public.attempt_submissions;
drop policy if exists "Signed-in users submit attempts for review" on public.attempt_submissions;
drop policy if exists "Signed-in users can submit their own attempt once" on public.attempt_submissions;
create policy "Signed-in users can submit their own attempt once"
on public.attempt_submissions for insert to authenticated
with check (
  user_id = (select auth.uid())
  and is_public = false
  and is_reviewed = false
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
drop policy if exists "Users can view own attempts" on public.attempt_submissions;
drop policy if exists "Users see their own attempts; public sees approved; admins see all" on public.attempt_submissions;
create policy "Users see their own attempts; public sees approved; admins see all"
on public.attempt_submissions for select to anon, authenticated
using (
  is_public = true
  or user_id = (select auth.uid())
  or (select auth.jwt())->'app_metadata'->>'role' = 'admin'
);

-- Students can attach a photo to their own pending attempt, but cannot edit their answer,
-- ownership, score/time, review status, or publication state.
revoke update on table public.attempt_submissions from authenticated;
grant update (is_public, is_reviewed, photo_path) on table public.attempt_submissions to authenticated;
drop policy if exists "Users can attach photo to own pending attempts" on public.attempt_submissions;
create policy "Users can attach photo to own pending attempts"
on public.attempt_submissions for update to authenticated
using (user_id = (select auth.uid()) and is_public = false and is_reviewed = false)
with check (user_id = (select auth.uid()) and is_public = false and is_reviewed = false);
