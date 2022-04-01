with all_ao_tickets as (
select distinct _sdc_source_key_id from pantheon.zendesk.tickets__tags where value = 'tu_less_than_three_years'
  )
select
[created_at:month] as month
,count (distinct ticket_id)
from pantheon.canonical.zendesk_interactions
inner join pantheon.all_ao_tickets on zendesk_interactions.ticket_id = all_ao_tickets._sdc_source_key_id
where brand_name = 'Trade'
group by 1
order by 1 desc