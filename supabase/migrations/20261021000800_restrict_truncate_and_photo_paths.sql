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
