select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'reqops_trade_6mosamliddoc' or value = 'reqops_trade_iddocamltudetails' or value = 'reqops_trade_3yraml')
group by 1, 3