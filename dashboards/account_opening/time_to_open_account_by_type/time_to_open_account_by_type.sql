with t as (
  select 
                case 
                  when account_seconds_to_open.seconds_to_open <= 30  then 'less than 30 sec'
                  when account_seconds_to_open.seconds_to_open <= 60  then 'less than a minute'
                  when account_seconds_to_open.seconds_to_open <= 86400  then 'less than a day'
                  when account_seconds_to_open.seconds_to_open <= 604800  then 'less than a week'
                else 'more than a week'
                end as diff,
--  count(account_seconds_to_open.id) as number_of_accounts,
    account_seconds_to_open.created_at_utc,
    account_seconds_to_open.type,
    account_seconds_to_open.branch_id
  from pantheon.[account_seconds_to_open]
  where [created_at_utc=daterange]
  and [type=so_account_type]
  and [branch_id=branch_id]
)
select 
  diff,
  count(*),
  type,
  branch_id,
  [created_at_utc:aggregation]
from pantheon.t
group by diff, type, branch_id, [created_at_utc:aggregation]