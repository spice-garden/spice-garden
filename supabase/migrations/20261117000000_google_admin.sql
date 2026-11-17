begin;

-- OAuth sign-in time survives access-token refresh. Google is the only enabled
-- OAuth provider for this project. A verified Google identity and an explicitly
-- allowlisted user ID are also required.
create or replace function public.menu_admin_expires_at() returns timestamptz
language sql stable security definer set search_path = '' as $$
  select pg_catalog.to_timestamp(max((entry->>'timestamp')::double precision)) + interval '2 hours'
  from pg_catalog.jsonb_array_elements(coalesce(auth.jwt()->'amr', '[]'::jsonb)) entry
  where entry->>'method' = 'oauth'
    and entry->>'timestamp' ~ '^[0-9]{1,12}$'
    and exists (
      select 1 from private.menu_admin admin
      join auth.identities identity on identity.user_id = admin.user_id
      where admin.user_id = auth.uid()
        and identity.provider = 'google'
        and identity.identity_data->>'email_verified' = 'true'
    );
$$;

commit;
