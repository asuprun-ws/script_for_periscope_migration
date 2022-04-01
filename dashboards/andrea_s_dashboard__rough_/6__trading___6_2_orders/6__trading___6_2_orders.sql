select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '6_2_1_rejection' or value = '6_2_2_cancellation_request' or value = '6_2_3_technical_issue' or value = '6_2_4_delayed_fulfillment' or value = '6_2_5_manual_order_request' or value = '6_2_6_order_type_request' or value = '6_2_7_order_explanation')
group by 1, 3