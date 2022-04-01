select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '3_1_adding_a_bank_account' or value = '3_2_deposits' or value = '3_3_internal_transfers' or value = '3_4_institutional_transfers')
group by 1, 3