select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '6_1_day_trading' or value = '6_2_orders' or value = '6_3_quotes' or value = '6_4_assets')
group by 1, 3