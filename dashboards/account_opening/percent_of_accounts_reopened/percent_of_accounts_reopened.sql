with ordered_open as (
    select id,
           status,
           type,
           updated_at_utc,
           rank() over(partition by id order by updated_at_utc) as rank
    from pantheon.so_accounts.accounts_revisions
    where (status = 'OPEN' or status = 'ACTION_REQUIRED')
  and [created_at_utc=daterange]
  and [type=so_account_type]
),
     action_required_table as (
         select id,
                type,
                max(rank) over (partition by id, status) as max_action_required
         from pantheon.ordered_open
         where status = 'ACTION_REQUIRED'
     ),
     any_time_reopened as (
         select distinct
             ordered_open.id,
             ordered_open.type,
             case when action_required_table.max_action_required > ordered_open.rank then 1 else 0 end as reopened
         from pantheon.ordered_open
                  left join pantheon.action_required_table on action_required_table.id = ordered_open.id
         where ordered_open.status = 'OPEN'
     ),
account_reopened as (
select
    id,
    type,
    sum(reopened) as reopened
from pantheon.any_time_reopened
group by id, type)
select
        (CAST(sum(reopened) as float) / CAST(count(*) as float)) as p
        --type
from pantheon.account_reopened
--group by type