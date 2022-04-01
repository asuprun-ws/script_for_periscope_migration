select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '2_1_kyc_details__personal_information_' or value = '2_2_getting_profile_started' or value = '2_3_app_download' or value = '2_4_account_opening')
group by 1, 3