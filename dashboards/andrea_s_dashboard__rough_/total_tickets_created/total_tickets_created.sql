select
[created_at:aggregation] as month
,count (distinct ticket_id)
from pantheon.canonical.zendesk_interactions
where brand_name = 'Trade' and [created_at=daterange]
group by 1
order by 1 desc