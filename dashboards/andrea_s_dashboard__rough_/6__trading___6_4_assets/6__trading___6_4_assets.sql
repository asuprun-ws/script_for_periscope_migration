select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '6_4_1_can_t_find_security' or value = '6_4_2_request_for_new_asset_type' or value = '6_4_3_supported_assets_101' or value = '6_4_4_corporate_actions')
group by 1, 3