begin;

-- Refreshing a JWT does not reset the original sign-in time.
create function public.menu_admin_expires_at() returns timestamptz
language sql stable security definer set search_path = '' as $$
  select pg_catalog.to_timestamp(max((entry->>'timestamp')::double precision)) + interval '2 hours'
  from pg_catalog.jsonb_array_elements(coalesce(auth.jwt()->'amr', '[]'::jsonb)) entry
  where entry->>'method' = 'otp'
    and entry->>'timestamp' ~ '^[0-9]{1,12}$'
    and exists(select 1 from private.menu_admin where user_id = auth.uid());
$$;
revoke all on function public.menu_admin_expires_at() from public;
grant execute on function public.menu_admin_expires_at() to authenticated;

create or replace function public.is_menu_admin() returns boolean
language sql stable security definer set search_path = '' as $$
  select coalesce(public.menu_admin_expires_at() > now(), false);
$$;

-- A shared counter serializes photo creation and counts imported gallery images.
create function private.legacy_photo_count(urls text[], cover text) returns integer
language sql immutable set search_path = '' as $$
  select count(distinct url)::integer from unnest(urls || array[cover]) url where nullif(url, '') is not null;
$$;
alter table public.menu_items add column uploaded_photo_count integer not null default 0;
update public.menu_items dish set uploaded_photo_count =
  (select count(*) from public.item_images photo where photo.item_id = dish.id);
alter table public.menu_items add constraint menu_photo_count_nonnegative check (uploaded_photo_count >= 0);

create function private.check_menu_photo_limit() returns trigger
language plpgsql set search_path = '' as $$
declare new_total integer;
begin
  new_total := new.uploaded_photo_count + private.legacy_photo_count(new.image_urls,new.image_url);
  if new_total <= 4 then return new; end if;
  if tg_op = 'UPDATE' then
    if new_total <= old.uploaded_photo_count + private.legacy_photo_count(old.image_urls,old.image_url) then
      return new;
    end if;
  end if;
  raise exception 'Each dish can have a maximum of four photos.' using
    errcode = '23514', constraint = 'menu_max_four_photos';
end;
$$;
create trigger menu_max_four_photos before insert or update on public.menu_items
for each row execute function private.check_menu_photo_limit();
grant usage on schema private to authenticated;
revoke all on function private.legacy_photo_count(text[], text) from public;
grant execute on function private.legacy_photo_count(text[], text) to authenticated;

revoke insert, update on public.menu_items from authenticated;
grant insert (name, category, diet, description, short_description, price_paise, paired_item_id, published,
  is_available, sort_order, image_urls, image_url, featured, special_on) on public.menu_items to authenticated;
grant update (name, category, diet, description, short_description, price_paise, paired_item_id, published,
  is_available, sort_order, image_urls, image_url, featured, special_on) on public.menu_items to authenticated;

create function private.track_menu_photo() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if tg_op = 'DELETE' then
    update public.menu_items set uploaded_photo_count = uploaded_photo_count - 1 where id = old.item_id;
    return old;
  end if;

  if tg_op = 'UPDATE' then
    if new.item_id <> old.item_id then
      raise exception 'Upload a new photo to move it to another dish.';
    end if;
    if new.thumbnail_path = old.thumbnail_path and new.image_path = old.image_path then
      return new;
    end if;
  end if;

  -- Fresh unique paths keep an in-progress upload outside the cleanup window.
  if new.thumbnail_path !~ ('^' || new.item_id::text || '/[0-9a-f-]{36}-thumb[.]webp$')
    or new.image_path <> regexp_replace(new.thumbnail_path, '-thumb[.]webp$', '-main.webp')
    or 2 <> (select count(*) from storage.objects
      where bucket_id = 'menu-photos' and name in (new.thumbnail_path,new.image_path)
      and created_at > now() - interval '1 hour') then
    raise exception 'Both new photo files must be uploaded before saving.';
  end if;

  if tg_op = 'INSERT' then
    update public.menu_items set uploaded_photo_count = uploaded_photo_count + 1 where id = new.item_id;
  end if;
  return new;
end;
$$;
revoke all on function private.track_menu_photo() from public;
create trigger track_menu_photo after insert or update or delete on public.item_images
for each row execute function private.track_menu_photo();

create function public.abandoned_menu_photos() returns setof text
language sql stable security definer set search_path = '' as $$
  select object.name from storage.objects object
  where public.is_menu_admin()
    and object.bucket_id = 'menu-photos'
    and object.name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}-(thumb|main)[.]webp$'
    and object.created_at < now() - interval '24 hours'
    and not exists(select 1 from public.item_images image
      where object.name in (image.thumbnail_path, image.image_path))
    and not exists(select 1 from public.menu_items dish
      cross join lateral unnest(dish.image_urls || array[dish.image_url]) url
      where split_part(split_part(url, '?', 1), '/menu-photos/', 2) = object.name)
  order by object.name limit 100;
$$;
revoke all on function public.abandoned_menu_photos() from public;
grant execute on function public.abandoned_menu_photos() to authenticated;
commit;
