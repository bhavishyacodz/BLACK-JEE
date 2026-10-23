-- Regression smoke test for the PYQ solution gate.
-- Run only in a disposable/staging project or SQL session that supports transactions.
-- All test attempt rows are rolled back. Requires at least one published PYQ and two auth users.
begin;

do $test$
declare
  v_question uuid;
  v_user_one uuid;
  v_user_two uuid;
  v_result jsonb;
begin
  select id into v_question
  from public.jee_pyq_questions
  where is_published = true
  order by created_at
  limit 1;

  select id into v_user_one from auth.users order by created_at limit 1;
  select id into v_user_two from auth.users where id <> v_user_one order by created_at desc limit 1;

  if v_question is null then
    raise exception 'Test requires at least one published PYQ.';
  end if;
  if v_user_one is null or v_user_two is null then
    raise exception 'Test requires two auth users to validate attempt isolation.';
  end if;

  -- Anonymous callers can check correctness but must not receive the key or solution.
  perform set_config('request.jwt.claim.sub', '', true);
  v_result := public.grade_jee_pyq(v_question, '__BLACKJEE_TEST_WRONG__');
  if v_result ? 'correct_answer' or v_result ? 'solution' then
    raise exception 'Anonymous grading leaked answer-key fields: %', v_result;
  end if;
  if coalesce((v_result->>'requires_sign_in')::boolean, false) is not true then
    raise exception 'Anonymous grading did not require sign-in for solution access: %', v_result;
  end if;

  -- A signed-in user's first wrong answer must not unlock the solution.
  perform set_config('request.jwt.claim.sub', v_user_one::text, true);
  v_result := public.grade_jee_pyq(v_question, '__BLACKJEE_TEST_WRONG_A__');
  if coalesce((v_result->>'solution_unlocked')::boolean, true) then
    raise exception 'Solution unlocked after only one wrong answer: %', v_result;
  end if;
  if coalesce((v_result->>'wrong_attempts')::integer, 0) <> 1 then
    raise exception 'First wrong attempt count should be 1: %', v_result;
  end if;

  -- The second wrong answer unlocks the solution for that user.
  v_result := public.grade_jee_pyq(v_question, '__BLACKJEE_TEST_WRONG_B__');
  if coalesce((v_result->>'solution_unlocked')::boolean, false) is not true
     or not (v_result ? 'correct_answer')
     or not (v_result ? 'solution') then
    raise exception 'Second wrong answer did not unlock the expected fields: %', v_result;
  end if;

  -- A different user starts with an independent attempt counter.
  perform set_config('request.jwt.claim.sub', v_user_two::text, true);
  v_result := public.grade_jee_pyq(v_question, '__BLACKJEE_TEST_WRONG_C__');
  if coalesce((v_result->>'solution_unlocked')::boolean, true) then
    raise exception 'One user's attempts leaked to another user: %', v_result;
  end if;
  if coalesce((v_result->>'wrong_attempts')::integer, 0) <> 1 then
    raise exception 'Second user should have an independent count of 1: %', v_result;
  end if;
end;
$test$;

rollback;
