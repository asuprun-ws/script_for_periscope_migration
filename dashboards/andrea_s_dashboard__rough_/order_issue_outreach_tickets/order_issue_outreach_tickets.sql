select value, count(value), date_trunc('week',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'trade_orderissue_041119' or value = 'trade_orderissue_040519' or value = 'trade_orderissue_032819')
group by 1, 3