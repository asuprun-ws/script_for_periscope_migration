select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'request_trade_internaltransfer')
group by 1, 3