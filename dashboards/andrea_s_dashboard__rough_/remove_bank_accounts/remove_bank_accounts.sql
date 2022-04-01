select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '3_1_4_remove_bank_account' or value = 'reqops_trade_removebankacct')
group by 1, 3