select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = '1_wealthsimple_trade_101' or value = '2_creating_an_account' or value = '3_funding_an_account' or value = '4_account_maintenance' or value = '5_security' or value = '6_trading' or value = '7_taxes' or value = '8_money_outflows' or value = '9_non-support' or value = '10_feedback__inbound_' or value = '11_nps')
group by 1, 3