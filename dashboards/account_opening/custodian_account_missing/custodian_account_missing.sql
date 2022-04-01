with missing as (
select 
  case when custodian_accounts.id is null then 0 else 1 end as custodian_account_exists,
  accounts.created_at
from pantheon.account_service.accounts
left join pantheon.account_service.custodian_accounts on accounts.id = custodian_accounts.account_id and custodian_accounts.type = 'so'
--left join pantheon.so_accounts.accounts as so_a on custodian_accounts.custodian_account_id = so_a.id
where [accounts.created_at=DateRange]
)
select 
  sum(custodian_account_exists) as num_missing_custodian,
  count(*) as totoal_accounts_created,
  [created_at:aggregation]
from pantheon.missing
group by [created_at:aggregation]