begin;

alter table public.homepage_settings
  add column default_banner_path text
  check (default_banner_path ~ '^banner/[0-9a-f-]{36}-banner[.]webp$');

create or replace function public.abandoned_menu_photos() returns setof text
language sql stable security definer set search_path = '' as $$
  select object.name from storage.objects object
  where public.is_menu_admin()
    and object.bucket_id = 'menu-photos'
    and (object.name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}-(thumb|main)[.]webp$'
      or object.name ~ '^banner/[0-9a-f-]{36}-banner[.]webp$')
    and not exists(select 1 from public.homepage_settings where default_banner_path = object.name)
    and object.created_at < now() - interval '24 hours'
    and not exists(select 1 from public.item_images image
      where object.name in (image.thumbnail_path, image.image_path))
    and not exists(select 1 from public.menu_items dish
      cross join lateral unnest(dish.image_urls || array[dish.image_url]) url
      where split_part(split_part(url, '?', 1), '/menu-photos/', 2) = object.name)
  order by object.name limit 100;
$$;
commit;
