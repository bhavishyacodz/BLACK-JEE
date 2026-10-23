-- Defense in depth: RLS does not apply to TRUNCATE, so browser roles must never hold it.
-- PYQ answer keys are admin-only; anonymous callers need no direct access to that table.
revoke all on table public.jee_pyq_answer_keys from anon, public;
grant select, insert, update, delete on table public.jee_pyq_answer_keys to authenticated;
revoke references, trigger, truncate on table public.jee_pyq_answer_keys from authenticated;

-- Public users may read published questions through RLS, but cannot mutate or truncate them.
revoke insert, update, delete, references, trigger, truncate
  on table public.jee_pyq_questions from anon, public;
revoke references, trigger, truncate on table public.jee_pyq_questions from authenticated;
