-- generate list of funds transfers
with funds_transfers_list as (
select
      funds_transfer_id
  , account_id    
  , funds_transfers.aasm_state current_state
      , funds_transfers.amount
      , funds_transfers.canonical_id
      , funds_transfers.post_dated
      , min(case when state = 'sm_created' then transitioned_at else null end) created
      , min(case when state = 'sm_pending_account_opening' then transitioned_at else null end) pending_account_opening
      , case
        when min(case when state = 'sm_pending_account_opening' then transitioned_at else null end) is null
          then null
        when max(transitioned_at) = max(case when state = 'sm_pending_account_opening' then transitioned_at else null end)
          then datediff(minute, max(transitioned_at), current_date)
        else
          datediff(minute, 
            max(case when state = 'sm_pending_account_opening' then transitioned_at else null end), 
            min(case when state in ('sm_pending_due_date', 'sm_pending_custodian_notification', 'sm_pending_banking', 'sm_cancelled') then transitioned_at else null end)
          )
      end as time_pending_account_opening_in_minutes
      , min(case when state = 'sm_pending_banking' then transitioned_at else null end) pending_banking
      , case
        when min(case when state = 'sm_pending_banking' then transitioned_at else null end) is null
          then null
        when max(transitioned_at) = max(case when state = 'sm_pending_banking' then transitioned_at else null end)
          then datediff(minute, max(transitioned_at), current_date)
        else
          datediff(minute, 
            max(case when state = 'sm_pending_banking' then transitioned_at else null end), 
            min(case when state in ('sm_pending_due_date', 'sm_pending_custodian_notification', 'sm_cancelled') then transitioned_at else null end)
          )
        end as time_pending_banking_in_minutes
      , min(case when state in ('sm_pending_due_date', 'sm_pending_custodian_notification', 'sm_scheduled_custodian_notification') then transitioned_at else null end) ready_to_notify_custodian
      , min(case when state in ('sm_custodian_notified', 'sm_processed') then transitioned_at else null end) processed
      , min(case when state = 'sm_accepted' then transitioned_at else null end) accepted
      , min(case when state = 'sm_rejected' then transitioned_at else null end) rejected
      , min(case when state = 'sm_cancelled' then transitioned_at else null end) cancelled

      , case when(min(case when state = 'sm_accepted' then transitioned_at else null end) = max(case when state = 'sm_accepted' then transitioned_at else null end)) then 1 else 0 end as accepted_state
      , case when(min(case when state = 'sm_rejected' then transitioned_at else null end) = max(case when state = 'sm_rejected' then transitioned_at else null end)) then 1 else 0 end as rejected_state
      , case when((max(case when state = 'sm_rejected' then transitioned_at else null end) > max(case when state = 'sm_accepted' then transitioned_at else null end)) and reject_reason in ('NSF','nsf') ) then 1 else 0 end as returned_nsf

      , funds_transfers.reject_reason
    ,funds_transfers.bank_account_owner_id
    from pantheon.fort_knox.funds_transfer_state_histories
      left join pantheon.fort_knox.funds_transfers on
        funds_transfer_state_histories.funds_transfer_id = funds_transfers.id
    where
      funds_transfers.created_at >= '2018-01-01'
      and funds_transfers.funding_type = 'deposit' 
    group by
      funds_transfer_id
      , funds_transfers.aasm_state
      , funds_transfers.amount
      , funds_transfers.canonical_id
      , funds_transfers.reject_reason
      , funds_transfers.post_dated
  , funds_transfers.account_id
      ,funds_transfers.bank_account_owner_id
  )
-- generate only blocked funds transfers
,blocked_funds_transfers as (
select
case when 
  processed is not null then date(processed)
  when cancelled is not null then date(cancelled)
  else null
  end as terminal_date
,account_facts.client_canonical_id
,account_facts.account_canonical_id
,account_facts.custodian_account_id
,account_facts.product
,account_facts.business_unit
,account_facts.business_unit_product
,current_state
,amount
,funds_transfers_list.canonical_id as funds_transfer_id
,time_pending_account_opening_in_minutes
,time_pending_banking_in_minutes
,case when time_pending_banking_in_minutes >= 240 then bank_account_owner_id else null end as bank_account_owner_id
from pantheon.funds_transfers_list
left join pantheon.fort_knox.accounts on funds_transfers_list.account_id = accounts.id
left join pantheon.canonical.account_facts on accounts.canonical_id = account_facts.account_canonical_id
-- left join pantheon.fort_knox.account_owners on accounts.id = account_owners.account_id
-- left join pantheon.fort_knox.clients on account_owners.client_id = clients.id
-- inner join pantheon.canonical.people on clients.canonical_id = people.client_canonical_id
-- left join pantheon.canonical.account_facts on accounts.canonical_id = account_facts.
-- where time_pending_account_opening_in_minutes >= 240 or time_pending_banking_in_minutes >= 240
and account_facts.ownership_type = 'primary'
and account_canonical_id is not null
)
-- clean transaction set
,clean_transactions as (
select
*
from pantheon.blocked_funds_transfers
where terminal_date is not null
and product = 'Trade'
and business_unit = 'CA Retail'
and custodian_account_id not like '1%'
and custodian_account_id not like '6%'
and client_canonical_id not in (select
slug
from pantheon.wealthsimple.users
where suspended_at is not null)
  )
-- only first funds transfers
,only_first as (
select
*
from pantheon.clean_transactions
where funds_transfer_id in (with ordered_account_transactions as (
select 
account_id
,canonical_id
,updated_at
,row_number() over (partition by account_id order by updated_at) as seq
from pantheon.fort_knox.funds_transfers
)
,first_account_funding as (
select
distinct canonical_id
from pantheon.ordered_account_transactions
where seq = 1
  )
,ordered_bank_account_transactions as (
select 
bank_account_owner_id
,canonical_id
,updated_at
,row_number() over (partition by bank_account_owner_id order by updated_at) as seq
from pantheon.fort_knox.funds_transfers
  )
, first_bank_funding as (
select
distinct canonical_id
from pantheon.ordered_bank_account_transactions
where seq = 1
  )
,table_union as (
select canonical_id from pantheon.first_account_funding
union
select canonical_id from pantheon.first_bank_funding
  )
select distinct canonical_id
from pantheon.table_union)
  )
select
[terminal_date:month] as terminal_date
,sum(case when current_state != 'sm_cancelled' then 1 else 0 end) as accepted
,sum(case when current_state = 'sm_cancelled' then 1 else 0 end) as cancelled
,sum(case when current_state != 'sm_cancelled' then 1 else 0 end) * 1.0 / (sum(case when current_state != 'sm_cancelled' then 1 else 0 end) + sum(case when current_state = 'sm_cancelled' then 1 else 0 end)) as capture_rate
from pantheon.only_first
group by 1
order by 1 desc