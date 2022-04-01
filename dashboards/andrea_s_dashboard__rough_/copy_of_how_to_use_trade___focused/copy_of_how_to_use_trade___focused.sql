select value, count(value), date_trunc('year',_sdc_received_at)
from zendesk.tickets__tags
where (value = 'reqops_trade_tucontact' or value ='reqops_trade_confirmaddress' or value = 'reqops_trade_confirmdob' or value = 'reqops_trade_confirmsin' or value = 'reqops_trade_confirmlastname' or value = 'reqops_trade_3yraml' or value = 'reqops_trade_6mosiddoc' or value = 'reqops_trade_6mosamliddoc' or value = 'reqops_trade_iddocamltudetails' or value = 'reqops_trade_iddoctudetails' or value = 'reqops_trade_aodetailsgood' or value 'trade_reqops_aodocreceived' or value = 'trade_reqops_aofollowup' or value = 'reqops_trade_tu' or value = 'reqops_trade_otherdocs' or value = 'reqops_trade_sinempty' or value = 'trade_reqops_notpdf' or value = 'trade_reqops_tradeopenbcsinvest')
group by 1, 3