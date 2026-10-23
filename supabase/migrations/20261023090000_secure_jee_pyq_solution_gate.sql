-- Server-enforced PYQ solution gate.
-- Public callers can check correctness, but answer keys/solutions are withheld until
-- an authenticated user has submitted two incorrect answers for the same question.

create table if not exists private.jee_pyq_answer_attempts (
  user_id uuid not null references auth.users(id) on delete cascade,
  question_id uuid not null references public.jee_pyq_questions(id) on delete cascade,
  wrong_attempts integer not null default 0 check (wrong_attempts between 0 and 2),
  first_attempt_at timestamptz not null default now(),
  last_attempt_at timestamptz not null default now(),
  solution_unlocked_at timestamptz,
  primary key (user_id, question_id)
);

alter table private.jee_pyq_answer_attempts enable row level security;
revoke all on table private.jee_pyq_answer_attempts from anon, authenticated, public;

create or replace function public.grade_jee_pyq(p_question_id uuid, p_answer text)
returns jsonb
language plpgsql
security definer
set search_path to ''
as $function$
declare
  v_user_id uuid := auth.uid();
  v_answer_key text;
  v_solution text;
  v_published boolean;
  v_correct boolean;
  v_wrong_attempts integer := 0;
  v_unlocked_at timestamptz;
  v_unlocked boolean := false;
begin
  select q.is_published, k.correct_answer, k.solution
    into v_published, v_answer_key, v_solution
  from public.jee_pyq_questions as q
  join public.jee_pyq_answer_keys as k on k.question_id = q.id
  where q.id = p_question_id;

  if not found or v_published is distinct from true then
    raise exception 'Question is not available for grading';
  end if;

  v_correct := upper(trim(coalesce(p_answer, ''))) = upper(trim(coalesce(v_answer_key, '')));

  -- Anonymous practice can still check correctness, but cannot retrieve the key.
  -- No client-supplied identifier is accepted as proof of identity.
  if v_user_id is null then
    return jsonb_build_object(
      'is_correct', v_correct,
      'solution_unlocked', false,
      'requires_sign_in', true,
      'wrong_attempts', 0,
      'attempts_until_solution', 2,
      'message', 'Sign in with Google to track attempts and unlock the worked solution after two incorrect answers.'
    );
  end if;

  insert into private.jee_pyq_answer_attempts as existing
    (user_id, question_id, wrong_attempts, first_attempt_at, last_attempt_at, solution_unlocked_at)
  values
    (v_user_id, p_question_id, case when v_correct then 0 else 1 end, now(), now(), null)
  on conflict (user_id, question_id) do update set
    wrong_attempts = case
      when existing.solution_unlocked_at is not null then existing.wrong_attempts
      when v_correct then existing.wrong_attempts
      else least(existing.wrong_attempts + 1, 2)
    end,
    last_attempt_at = now(),
    solution_unlocked_at = coalesce(
      existing.solution_unlocked_at,
      case when not v_correct and existing.wrong_attempts + 1 >= 2 then now() else null end
    )
  returning wrong_attempts, solution_unlocked_at
    into v_wrong_attempts, v_unlocked_at;

  v_unlocked := v_unlocked_at is not null;

  if v_unlocked then
    return jsonb_build_object(
      'is_correct', v_correct,
      'solution_unlocked', true,
      'requires_sign_in', false,
      'wrong_attempts', v_wrong_attempts,
      'attempts_until_solution', 0,
      'correct_answer', v_answer_key,
      'solution', coalesce(v_solution, ''),
      'message', 'Worked solution unlocked.'
    );
  end if;

  return jsonb_build_object(
    'is_correct', v_correct,
    'solution_unlocked', false,
    'requires_sign_in', false,
    'wrong_attempts', v_wrong_attempts,
    'attempts_until_solution', greatest(0, 2 - v_wrong_attempts),
    'message', case when v_correct
      then 'Correct. The worked solution remains available after two incorrect attempts.'
      else 'Incorrect answer. The worked solution unlocks after two incorrect attempts.'
    end
  );
end;
$function$;

revoke all on function public.grade_jee_pyq(uuid, text) from public;
grant execute on function public.grade_jee_pyq(uuid, text) to anon, authenticated;
