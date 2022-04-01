select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '2_1_3_information_update')
group by 1, 3