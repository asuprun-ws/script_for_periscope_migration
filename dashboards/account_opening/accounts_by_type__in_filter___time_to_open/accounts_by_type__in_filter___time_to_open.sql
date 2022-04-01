select
       type,
       avg(account_seconds_to_open.minutes_to_open) as avg_time,
       percentile_cont(0.5) within group (order by account_seconds_to_open.minutes_to_open) as percentile_50,
       percentile_cont(0.90) within group (order by account_seconds_to_open.minutes_to_open) as percentile_90,
       percentile_cont(0.95) within group (order by account_seconds_to_open.minutes_to_open) as percentile_95,
      [created_at_utc:aggregation]
from pantheon.[account_seconds_to_open]
where [created_at_utc=daterange]
and [type=so_account_type]
group by type, [created_at_utc:aggregation]