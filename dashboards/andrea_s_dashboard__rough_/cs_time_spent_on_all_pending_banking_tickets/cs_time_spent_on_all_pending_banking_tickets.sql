with internal_transfer_tickets as (
select _sdc_source_key_id from pantheon.zendesk.tickets__tags
where value = 'autocut_sm_pending_banking'
  )
select 
[created_at:month] as summary_date
,count (distinct ticket_id) as tickets_actioned
,(sum(time_tracker_numeric)) * 1.0 / 60 as minutes_spent
from pantheon.canonical.zendesk_interactions
inner join pantheon.internal_transfer_tickets on zendesk_interactions.ticket_id = internal_transfer_tickets._sdc_source_key_id
where brand_name = 'Trade'
group by 1
order by 1 desc