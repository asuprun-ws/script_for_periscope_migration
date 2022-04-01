with required_actions as (
  select
    case 
      when (action = 'SIGN_AGREEMENTS' and people.id is null) then 'SIGN_AGREEMENTS (reg firm + interested party)'
      when action = 'RESOLVE_CLIENT_COMPLIANCE_FLAGS' and compliance_flags.category = 'NON_RESIDENT' then 'COMPLIANCE_FLAGS (non-resident)'
      when (action = 'SIGN_AGREEMENTS' and account_clients.role != 'PRIMARY_OWNER') then 'SIGN_AGREEMENTS (non-primary owner)'
      else action
    end as requirement,
    accounts.created_at_utc
  from pantheon.so_accounts.accounts
  left join pantheon.so_accounts.account_required_actions on accounts.id = account_required_actions.account_id
  left join pantheon.so_clients.people on people.id = account_required_actions.target_id
  left join pantheon.so_accounts.account_clients on account_clients.client_id = people.id
  left join pantheon.so_clients.compliance_flags on compliance_flags.person_id = account_required_actions.target_id
  where accounts.status = 'ACTION_REQUIRED'
  and [accounts.created_at_utc=daterange]
  and accounts.type in ('CA_JOINT')
)
select 
  required_actions.requirement,
  count(*), 
  [created_at_utc:aggregation]
from pantheon.required_actions
group by required_actions.requirement, [created_at_utc:aggregation]