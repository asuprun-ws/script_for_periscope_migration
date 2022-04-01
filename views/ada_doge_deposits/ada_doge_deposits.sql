select
  accounts.user_id,
  accounts.paired_account_id,
  transfers.canonical_id,
  transfers.external_id,
  status,
  external_status,
  asset_id,
  net_amount,
  confirmations,
  tx_hash,
  transfers.created_at,
  transfers.updated_at,
  amount,
  amount_usd
from crypto_service.transfers
left join crypto_service.accounts
on transfers.account_id = accounts.id
where transfer_type = 'deposit' and (asset_id = 'ADA' or asset_id = 'DOGE')
order by created_at desc