select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '9_5_duplicate_ticket')
group by 1, 3