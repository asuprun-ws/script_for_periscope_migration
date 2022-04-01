select
       CASE WHEN a.type like '%NEW_ACCOUNT' then 'NEW ACCOUNT AGREEMENT (ANY)'
       else a.type
       end as type,
       [accounts.created_at_utc:aggregation],
       count(*)
from pantheon.so_accounts.accounts
left join pantheon.so_accounts.account_required_actions on accounts.id = account_required_actions.account_id
left join pantheon.so_accounts.agreements_accounts aa on accounts.id = aa.account_id
left join pantheon.so_accounts.agreements a on aa.agreement_id = a.id
where accounts.status = 'ACTION_REQUIRED'
    and account_required_actions.action = 'SIGN_AGREEMENTS'
    and a.signed_at_utc is null
    and a.voided_at_utc is null
    and [accounts.created_at_utc=daterange]
    and a.type not in ('CA_REGISTERED_BENEFICIARY', 'CA_TFSA_SUCCESSOR', 'CA_REGISTERED_NO_ESTATE', 'CA_RIF_SUCCESSOR', 'INTERESTED_PARTY_DISCLOSURE', 'CA_REGISTERED_CONTINGENT_BENEFICIARY')
group by a.type, [accounts.created_at_utc:aggregation]