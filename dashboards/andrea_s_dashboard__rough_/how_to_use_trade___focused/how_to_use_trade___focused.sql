select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'genops_trade_withdraw' or value ='genops_trade_findagreements' or value = 'reqops_trade_removebankacct' or value = 'reqops_trade_closeprofile' or value = 'request_trade_watchlistnav' or value = 'genops_trade_downloadapp' or value = 'genq_trade_bidaskspread' or value = '3_1_4_remove_bank_account')
group by 1, 3