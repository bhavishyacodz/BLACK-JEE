create or replace function public.restore_submitted_challenge_attempt(p_question_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_uid uuid := auth.uid();
  v_question public.daily_questions%rowtype;
  v_started timestamptz;
begin
  if v_uid is null then
    raise exception 'Sign in to restore your submitted attempt.' using errcode = '28000';
  end if;

  select q.* into v_question
  from public.daily_questions q
  where q.id = p_question_id
    and q.is_live = true
    and q.starts_at <= now()
    and q.ends_at > now();

  if not found then
    raise exception 'This challenge is no longer open.';
  end if;

  if not exists (
    select 1 from public.attempt_submissions s
    where s.question_id = p_question_id and s.user_id = v_uid
  ) then
    raise exception 'No submitted attempt was found for this account.';
  end if;

  select s.started_at into v_started
  from private.challenge_attempt_sessions s
  where s.question_id = p_question_id and s.user_id = v_uid;

  if v_started is null then
    raise exception 'The attempt session could not be restored.';
  end if;

  -- Restores only the question the student already attempted.
  -- Never returns the answer key or worked solution.
  return jsonb_build_object(
    'started_at', v_started,
    'id', v_question.id,
    'question_date', v_question.question_date,
    'title', v_question.title,
    'statement', v_question.statement,
    'tags', coalesce(to_jsonb(v_question.tags), '[]'::jsonb),
    'difficulty', v_question.difficulty,
    'options', coalesce(to_jsonb(v_question.options), '[]'::jsonb),
    'challenge_type', v_question.challenge_type,
    'solution_published', false,
    'url', null
  );
end;
$function$;

revoke all on function public.restore_submitted_challenge_attempt(uuid) from public, anon;
grant execute on function public.restore_submitted_challenge_attempt(uuid) to authenticated, service_role;
