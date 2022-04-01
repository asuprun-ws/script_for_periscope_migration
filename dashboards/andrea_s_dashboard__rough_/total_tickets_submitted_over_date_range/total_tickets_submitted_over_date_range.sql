SELECT count(ticket_id)
FROM canonical.zendesk_interactions
WHERE brand_name = 'Trade' and [created_at=daterange]