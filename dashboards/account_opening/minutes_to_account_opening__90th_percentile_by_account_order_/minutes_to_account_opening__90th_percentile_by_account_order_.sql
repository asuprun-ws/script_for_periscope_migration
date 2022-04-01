with subsequent_accounts as (
  select s.*,
    case when c.rank = 1 then 'first'
    else 'subsequent' end as account_rank
  from pantheon.[account_order_created as c]
  left join pantheon.[account_seconds_to_open as s] on c.account_id = s.id
)
select
       type,
       account_rank,
       [created_at_utc:aggregation],
       percentile_cont(0.5) within group (order by a.minutes_to_open) as percentile_50,
       percentile_cont(0.90) within group (order by a.minutes_to_open) as percentile_90
       --percentile_cont(0.95) within group (order by a.minutes_to_open) as percentile_95
from pantheon.subsequent_accounts as a
where [created_at_utc=daterange]
and [type=so_account_type]
group by 1, 2, 3