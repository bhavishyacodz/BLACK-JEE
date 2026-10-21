-- Add covering indexes for foreign keys identified by Supabase performance advisors.
create index if not exists challenge_attempt_sessions_user_id_idx
  on private.challenge_attempt_sessions(user_id);
create index if not exists active_question_links_updated_by_idx
  on public.active_question_links(updated_by);
create index if not exists attempt_submissions_question_link_id_idx
  on public.attempt_submissions(question_link_id);

-- Evaluate JWT claims once per statement rather than repeatedly per row.
drop policy if exists "Admins can publish question link" on public.active_question_links;
create policy "Admins can publish question link"
  on public.active_question_links for insert to authenticated
  with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admins can update question link" on public.active_question_links;
create policy "Admins can update question link"
  on public.active_question_links for update to authenticated
  using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin')
  with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admins can delete question link" on public.active_question_links;
create policy "Admins can delete question link"
  on public.active_question_links for delete to authenticated
  using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');
