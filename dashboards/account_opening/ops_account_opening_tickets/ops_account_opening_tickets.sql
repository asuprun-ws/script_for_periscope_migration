select
  [created_at:aggregation]
  , issue_type                    
  , count(1)
from pantheon.backoffice_transactions.manual_account_opening
where
  [created_at=DateRange]
  and [created_at:aggregation] <> date_trunc('[aggregation]', [daterange_start]::timestamp)::date
group by
  1, 2
order by 
  1, 2 desc