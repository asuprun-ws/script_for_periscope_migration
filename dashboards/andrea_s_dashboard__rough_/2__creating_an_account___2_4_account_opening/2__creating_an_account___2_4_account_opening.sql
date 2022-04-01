select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '2_4_1_account_opening_blocker' or value = '2_4_2_trade_account_types' or value = '2_4_3_account_types_101')
group by 1, 3