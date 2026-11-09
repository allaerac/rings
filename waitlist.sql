-- Already applied to the Supabase project (migration "waitlist"). Kept here for the record.
-- The page's public (anon) key may only ADD a signup. Nobody can read the list with it.

create table if not exists public.waitlist (
  id         uuid primary key default gen_random_uuid(),
  email      text not null,
  role       text not null,
  source     text,
  created_at timestamptz not null default now(),
  constraint waitlist_email_format check (char_length(email) <= 254 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  constraint waitlist_role check (role in ('parent', 'student', 'other')),
  constraint waitlist_source_len check (source is null or char_length(source) <= 40)
);

-- one signup per email, whatever the capitals
create unique index if not exists waitlist_email_unique on public.waitlist (lower(email));

alter table public.waitlist enable row level security;

create policy "page can join the waitlist"
  on public.waitlist for insert
  to anon
  with check (true);

grant insert on public.waitlist to anon;
revoke select, update, delete on public.waitlist from anon;

-- Signups per day, parents vs students (Oxford time). Closed to the anon key.
create or replace view public.metric_waitlist with (security_invoker = true) as
select (created_at at time zone 'America/New_York')::date as day,
       count(*) as signups,
       count(*) filter (where role = 'parent') as parents,
       count(*) filter (where role = 'student') as students,
       count(*) filter (where role = 'other') as other
from public.waitlist
group by 1
order by 1;
