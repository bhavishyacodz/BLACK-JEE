-- Allow public pages to render only reviewed, explicitly published submissions.
-- Column-level grants keep private attempt fields inaccessible to anonymous clients.
grant select (
  id,
  question_id,
  display_name,
  photo_path,
  elapsed_seconds,
  created_at,
  is_public,
  is_reviewed
) on table public.attempt_submissions to anon;
