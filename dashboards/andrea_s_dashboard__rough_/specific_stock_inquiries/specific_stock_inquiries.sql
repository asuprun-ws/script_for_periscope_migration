select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'genq_trade_cantfindstock' or value ='genq_trade_stocknotcds' or value = 'genq_trade_compgoespublic ' or value ='genq_trade_cantbuystock')
group by 1, 3