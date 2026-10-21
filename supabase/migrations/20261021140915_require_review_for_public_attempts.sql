-- Public submissions and solution photos must be both published and reviewed.
-- Owners and admins retain their existing visibility.
drop policy if exists "Users see their own attempts; public sees approved; admins see " on public.attempt_submissions;
create policy "Users see own, admins see all, public sees reviewed submissions"
on public.attempt_submissions
for select
to anon, authenticated
using (
  (is_public = true and is_reviewed = true)
  or user_id = (select auth.uid())
  or coalesce(((select auth.jwt()) -> 'app_metadata' ->> 'role'), '') = 'admin'
);

drop policy if exists "Approved photos and admins can view attempt photos" on storage.objects;
create policy "Reviewed published photos and admins can view attempt photos"
on storage.objects
for select
to anon, authenticated
using (
  bucket_id = 'attempt-photos'
  and (
    coalesce(((select auth.jwt()) -> 'app_metadata' ->> 'role'), '') = 'admin'
    or exists (
      select 1
      from public.attempt_submissions s
      where s.photo_path = objects.name
        and s.is_public = true
        and s.is_reviewed = true
    )
  )
);
