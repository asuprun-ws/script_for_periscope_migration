select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'trade_corporateaction_escalate' or value = 'reqops_trade_corporate_actions' or value = 'issue_trade_dividenddelay' or value = 'reqops_trade_stocksplit')
group by 1, 3