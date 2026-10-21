-- BLACK JEE security audit: remove unnecessary table capabilities and
-- prevent a student from attaching another user's Storage object to their record.
begin;

revoke truncate, trigger, references
on table public.active_question_links, public.daily_questions, public.attempt_submissions
from anon, authenticated;

drop policy if exists "Users can attach photo to own pending attempts"
on public.attempt_submissions;

create policy "Users can attach photo to own pending attempts"
on public.attempt_submissions
for update
to authenticated
using (
  user_id = (select auth.uid())
  and is_public = false
  and is_reviewed = false
)
with check (
  user_id = (select auth.uid())
  and is_public = false
  and is_reviewed = false
  and (
    photo_path is null
    or left(photo_path, length(((select auth.uid())::text) || '/'))
       = ((select auth.uid())::text || '/')
  )
);

commit;
