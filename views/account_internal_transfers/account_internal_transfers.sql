select
   t.canonical_id
  ,t.created_at
  ,t.aasm_state
  ,t.transfer_type
  ,sa.canonical_id as source_account_canonical_id
  ,da.canonical_id as destination_account_canonical_id
  ,t.amount
  ,t.currency
  ,t.updated_at
  ,post_dated
  ,(case
      when t.post_dated::date > getdate()::date then true
      else false
    end) as is_post_dated
  ,(getdate()::date - t.created_at::date)::int as days_open
from pantheon.fort_knox.internal_transfers t
  join pantheon.fort_knox.accounts sa on t.source_account_id = sa.id
  join pantheon.fort_knox.accounts da on t.destination_account_id = da.id