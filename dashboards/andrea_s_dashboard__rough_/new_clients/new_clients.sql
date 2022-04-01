select
  [summary_date:aggregation] 
  , sum(newly_acquired) as acquired_clients 
  , -sum(newly_churned) as churned_clients
  , sum(newly_unchurned) as unchurned_clients

from pantheon.canonical.business_unit_client_daily_values

where
  [business_unit_product=BusinessUnitProduct] 
  and [summary_date=DateRange] 
  -- remove part months 
  and [summary_date:aggregation] <> date_trunc('[aggregation]', [daterange_start]::timestamp)::date  

group by 
  1
order by 
  1