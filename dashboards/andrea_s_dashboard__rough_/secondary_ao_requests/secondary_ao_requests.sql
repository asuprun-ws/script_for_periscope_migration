select value, count(value), date_trunc('month',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'reqops_trade_tucontact' or value = 'reqops_trade_iddocamltudetails' or value = 'reqops_trade_iddoctudetails' or value = 'reqops_trade_otherdocs' or value = 'trade_reqops_notpdf' or value = 'trade_reqops_differentaddressdoc' or value = 'reqops_trade_wrongiddoc' or value = 'trade_reqops_nopaystubs')
group by 1, 3