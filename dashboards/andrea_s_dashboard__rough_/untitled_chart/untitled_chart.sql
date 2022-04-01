select 
[tickets.created_at:aggregation],  
case when '[how]' = 'time_tracker_numeric/60' then sum([how])/60 else sum([how]) end
from [zd_tickets as tickets]
[zd_casedriver_filters]
and [tickets.created_at=Daterange]
WHERE 
group by 1,time_tracker_numeric,tickets.agent_comments
order by 1 desc