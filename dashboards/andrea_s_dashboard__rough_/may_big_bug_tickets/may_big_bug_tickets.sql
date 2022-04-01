select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'issue_trade_dblwithdrawal' or value = 'issue_trade_whitescreen_052219' or value = 'issue_trade_0518_incorrectbalance' or value = 'issue_trade_earningsoff' or value = 'issue_trade_depositerror' or value = 'issue_trade_vpnnoconnection' or value = 'issue_trade_roundingorderreject' or value = 'issue_trade_dupecutter' or value = 'issue_trade_spinneremail' or value = 'issue_trade_vdayholiday' or value = 'issue_trade_prpoissue' or value = 'issue_trade_orders_shortpositions' or value = 'issue_trade_amlshouldopen')
group by 1, 3