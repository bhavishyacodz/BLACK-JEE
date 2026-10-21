create policy "Authenticated users can read their own challenge sessions"
on private.challenge_attempt_sessions
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Authenticated users can insert their own challenge sessions"
on private.challenge_attempt_sessions
for insert
to authenticated
with check ((select auth.uid()) = user_id);
