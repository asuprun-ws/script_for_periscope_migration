select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '3_1_1_how-to' or value = '3_1_2_technical_issue' or value = '3_1_3_account_not_supported' or value = '3_1_4_remove_bank_account' or value = '3_2_1_how-to' or value = '3_2_2_rejected_eft' or value = '3_2_3_banking_blocker' or value = '3_2_4_kyc_blocker' or value = '3_2_5_cancel_deposit' or value = '3_2_6_deposit_delay' or value = '3_2_7_usd_deposits' or value = '3_2_8_manual_funding_request' or value = '3_2_9_technical_issue')
group by 1, 3