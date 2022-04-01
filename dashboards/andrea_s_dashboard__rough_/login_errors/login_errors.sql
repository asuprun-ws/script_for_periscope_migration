select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'genq_trade_invalidsin ' or value = 'reqops_trade_duplicateaccount')
group by 1, 3