-- Prevent signed-in students from querying the live question text/options directly.
-- Students receive the content through start_challenge_attempt() only after Start.
revoke select (statement, options) on public.daily_questions from authenticated;

-- The owner dashboard uses this guarded RPC to preview the current question.
create or replace function public.admin_get_live_question()
returns jsonb
language plpgsql
stable
security definer
set search_path to ''
as $function$
declare
  v_q public.daily_questions%rowtype;
begin
  if auth.uid() is null
     or coalesce(((select auth.jwt()) -> 'app_metadata' ->> 'role'), '') <> 'admin' then
    raise exception 'Admin permission required.' using errcode = '42501';
  end if;

  select q.* into v_q
  from public.daily_questions as q
  where q.is_live = true
    and q.question_date <= (now() at time zone 'Asia/Kolkata')::date
  order by q.question_date desc
  limit 1;

  if not found then
    select q.* into v_q
    from public.daily_questions as q
    where q.is_live = true and q.ends_at > now()
    order by q.question_date desc
    limit 1;
  end if;

  if not found then return null; end if;

  return jsonb_build_object(
    'id', v_q.id,
    'question_date', v_q.question_date,
    'title', v_q.title,
    'statement', v_q.statement,
    'tags', coalesce(to_jsonb(v_q.tags), '[]'::jsonb),
    'difficulty', v_q.difficulty,
    'options', coalesce(to_jsonb(v_q.options), '[]'::jsonb),
    'solution_published', false,
    'is_live', v_q.is_live,
    'created_at', v_q.created_at,
    'starts_at', v_q.starts_at,
    'ends_at', v_q.ends_at
  );
end;
$function$;

revoke all on function public.admin_get_live_question() from public, anon;
grant execute on function public.admin_get_live_question() to authenticated;
