-- Keep the official solution unpublished until six hours after the challenge closes.
-- Correct future rows that inherited the old TRUE default.
update public.daily_questions
set solution_published = false
where solution_published = true
  and ends_at is not null
  and now() < ends_at + interval '6 hours';

alter table public.daily_questions
  alter column solution_published set default false;

create or replace function private.enforce_solution_release_window()
returns trigger
language plpgsql
set search_path = ''
as $function$
begin
  if new.solution_published is true
     and new.ends_at is not null
     and now() < new.ends_at + interval '6 hours' then
    raise exception 'The official solution cannot be published before six hours after the challenge closes.'
      using errcode = '23514';
  end if;
  return new;
end;
$function$;

drop trigger if exists enforce_solution_release_window on public.daily_questions;
create trigger enforce_solution_release_window
before insert or update on public.daily_questions
for each row execute function private.enforce_solution_release_window();
