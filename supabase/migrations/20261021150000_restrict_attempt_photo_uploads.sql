-- Chunk 4 security hardening:
-- Only signed-in users may upload attempt photos, and only inside their own user-ID folder.
-- The frontend already uploads to auth.uid()/<uuid>-<filename>.
begin;

drop policy if exists "Visitors can upload attempt photos" on storage.objects;
drop policy if exists "Authenticated users upload own attempt photos" on storage.objects;

create policy "Authenticated users upload own attempt photos"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'attempt-photos'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

commit;
