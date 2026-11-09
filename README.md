# Rings waitlist

One page at **https://allaerac.github.io/rings/** where parents and students join the waitlist. Signups go to the `waitlist` table in the same Supabase project as the pilot app. The page can only add a signup, never read the list.

## Links to share
Add `?src=` so you can tell where signups came from:

| Where | Link |
|---|---|
| Facebook | https://allaerac.github.io/rings/?src=facebook |
| Instagram | https://allaerac.github.io/rings/?src=instagram |
| Text / group chats | https://allaerac.github.io/rings/?src=text |

Without `?src=`, the page records the site that sent them, or `direct`.

## Seeing signups
In Supabase: **Table Editor → waitlist** for the list, or **SQL Editor**:

```sql
-- per day, parents vs students
select * from metric_waitlist;

-- totals by who they are and where they came from
select role, source, count(*) from waitlist group by 1, 2 order by 3 desc;

-- the email list (Download CSV from the results)
select email, role, created_at from waitlist order by created_at;
```

## Files
`index.html` (the page, all in one file), `og.png` (the picture Facebook and texts show for the link), `icon.svg` and `apple-touch-icon.png` (from the app), `waitlist.sql` (the table, already applied).
