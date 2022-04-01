with automatic_and_total as (
  select 
    case when (a.seconds_to_open < 60) then 1
    else 0 end as automatic,
    a.seconds_to_open,
    a.type,
    a.branch_id,
    created_at_utc
  from pantheon.[account_seconds_to_open as a]
  where [created_at_utc=daterange]
  and [type=so_account_type]
  and [branch_id=branch_id]
  -- branch_id should account for KO 
  --and branch_id != 'KO'
)
select 
  (CAST(sum(automatic) as float) / CAST(count(*) as float)) as p,
  type,
  branch_id,
  [created_at_utc:aggregation]
from pantheon.automatic_and_total
group by type, branch_id, [created_at_utc:aggregation]