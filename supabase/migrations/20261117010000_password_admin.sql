begin;

-- The authentication timestamp survives access-token refresh.
create or replace function public.menu_admin_expires_at() returns timestamptz
language sql stable security definer set search_path = '' as $$
  select pg_catalog.to_timestamp(max((entry->>'timestamp')::double precision)) + interval '2 hours'
  from pg_catalog.jsonb_array_elements(coalesce(auth.jwt()->'amr', '[]'::jsonb)) entry
  where entry->>'method' = 'password'
    and entry->>'timestamp' ~ '^[0-9]{1,12}$'
    and exists (select 1 from private.menu_admin where user_id = auth.uid());
$$;

commit;
