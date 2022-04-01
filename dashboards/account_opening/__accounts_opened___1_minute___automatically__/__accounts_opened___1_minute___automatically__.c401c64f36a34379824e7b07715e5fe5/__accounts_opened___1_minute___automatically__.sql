with automatic_and_total as (
  select 
    case when (a.seconds_to_open < 60) then 1
    else 0 end as automatic,
    a.seconds_to_open,
    a.type
  from pantheon.[account_seconds_to_open as a]
  where [created_at_utc=daterange]
  and [type=so_account_type]
)
select 
  (CAST(sum(automatic) as float) / CAST(count(*) as float)) * 100 as p
from pantheon.automatic_and_total