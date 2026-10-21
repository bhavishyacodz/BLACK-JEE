-- The public challenge-link page needs read-only access only.
revoke insert, update, delete, references on table public.active_question_links from anon;
grant select (id, title, url, is_live, updated_at, updated_by)
  on table public.active_question_links to anon;

-- Public Hall of Proof needs only these fields; RLS still limits rows to published submissions.
revoke select on table public.attempt_submissions from anon;
grant select (id, question_id, display_name, photo_path, elapsed_seconds, created_at, is_public)
  on table public.attempt_submissions to anon;
