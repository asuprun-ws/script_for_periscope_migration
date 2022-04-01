select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'trade_reqops_newtuok')
group by 1, 3