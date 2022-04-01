select value, count(value), date_trunc('week',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'issue_trade_wrongplatform' or value = 'investvstrade')
group by 1, 3