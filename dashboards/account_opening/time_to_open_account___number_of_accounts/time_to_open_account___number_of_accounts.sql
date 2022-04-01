select
  type,
  sum(account_seconds_to_open.minutes_to_open) as sum_time_to_open,
  count(*) as num_accounts,
  [created_at_utc:aggregation]
from pantheon.[account_seconds_to_open]
where [created_at_utc=daterange]
and [type=so_account_type]
group by type, [created_at_utc:aggregation]