select 
    avg(seconds_to_open) / 60
  from pantheon.[account_seconds_to_open]
  where created_at_utc > now() - interval '1 day'
  and [type=so_account_type]
  and [branch_id=branch_id]