select
  [created_at:aggregation]
  , problem_area                    
  , count(1)
from pantheon.[clients_on_call]
where
  [created_at=DateRange]
  and [created_at:aggregation] <> date_trunc('[aggregation]', [daterange_start]::timestamp)::date
  and (problem_area like  'Account%' or problem_area like 'Agreements%' or problem_area like 'Funding%' or problem_area like 'Beneficiaries%') 
       --('Account Opening (account status, manual review)', 'Account values', 'Agreements (sign, resurface, update, W-8BEN)', 'Beneficiaries (name, DOB, etc.)', 'Funding intent (deposits, withdrawals, transfers)')
group by
  1, 2
order by 
  1, 2 desc