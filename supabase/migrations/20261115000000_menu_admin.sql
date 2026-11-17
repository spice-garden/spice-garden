begin;
create schema if not exists private;
create table private.menu_admin (user_id uuid primary key references auth.users on delete cascade);
revoke all on private.menu_admin from public, anon, authenticated;
create function public.is_menu_staff() returns boolean language sql stable security definer
set search_path = '' as $$
  select exists(select 1 from private.menu_admin where user_id = auth.uid())
$$;
revoke all on function public.is_menu_staff() from public;
grant execute on function public.is_menu_staff() to authenticated;

create function public.is_menu_admin() returns boolean language sql stable security definer
set search_path = '' as $$
  select coalesce(auth.jwt()->>'aal' = 'aal2', false)
    and exists(select 1 from private.menu_admin where user_id = auth.uid())
$$;
revoke all on function public.is_menu_admin() from public;
grant execute on function public.is_menu_admin() to anon, authenticated;

create table public.menu_categories (
  id text primary key default gen_random_uuid()::text,
  name text not null check (length(trim(name)) > 0),
  sort_order integer not null default 0,
  is_visible boolean not null default true
);
insert into public.menu_categories(id,name,sort_order) values
 ('soup','Soups',10),('salad','Salads',20),('starter','Starters',30),('main','Main Course',40),
 ('dessert','Desserts',50),('drink','Beverages',60),('side','Sides',70);

alter table public.menu_items
  add column if not exists image_urls text[] not null default '{}',
  add column if not exists video_url text check (video_url is null or video_url ~ '^https://'),
  add column if not exists is_available boolean not null default true;
alter table public.menu_items drop constraint menu_items_category_check;
alter table public.menu_items add foreign key(category) references public.menu_categories(id) on delete restrict;
alter table public.menu_items add column short_description text not null default '',
  add column paired_item_id uuid references public.menu_items(id) on delete set null,
  add constraint menu_no_self_pair check (paired_item_id is distinct from id);
alter table public.menu_items alter column diet drop default;
-- Legacy unknown classifications must be assigned explicitly before publication.
update public.menu_items set published = false where diet = 'unknown';
alter table public.menu_items add constraint published_menu_diet check (not published or diet in ('veg','non-veg'));
create unique index menu_unique_dish_name on public.menu_items
  (lower(btrim(regexp_replace(name, '[[:space:]]+', ' ', 'g'))));

create table public.special_collections (
  id text primary key default gen_random_uuid()::text,
  name text not null check (length(trim(name)) > 0),
  sort_order integer not null default 0,
  is_visible boolean not null default true
);
insert into public.special_collections(id,name,sort_order)
values ('chef-picks','Chef’s Picks',0),('today','Today’s Special',10);
create table public.collection_items (
  collection_id text references public.special_collections on delete cascade,
  item_id uuid references public.menu_items on delete cascade,
  sort_order integer not null default 0,
  primary key(collection_id,item_id)
);
insert into public.collection_items(collection_id,item_id,sort_order)
select 'chef-picks',id,sort_order from public.menu_items where featured;
create table public.item_images (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.menu_items on delete cascade,
  thumbnail_path text not null,
  image_path text not null,
  alt_text text not null default '',
  sort_order integer not null default 0
);
create function public.set_menu_cover(photo_id uuid) returns void language sql
set search_path = '' as $$
  with ranked as (
    select other.id, row_number() over(order by (other.id = photo_id) desc, other.sort_order, other.id) - 1 as position
    from public.item_images target
    join public.item_images other on other.item_id = target.item_id
    where target.id = photo_id
  )
  update public.item_images image set sort_order = ranked.position
  from ranked where image.id = ranked.id;
$$;
revoke all on function public.set_menu_cover(uuid) from public;
grant execute on function public.set_menu_cover(uuid) to authenticated;

create table public.homepage_settings (
  id integer primary key check (id = 1),
  featured_item_id uuid references public.menu_items on delete set null,
  headline_override text not null default '',
  subtitle_override text not null default ''
);
insert into public.homepage_settings(id,featured_item_id)
values (1,(select id from public.menu_items where featured and published and is_available order by sort_order,id limit 1));

drop policy "Guests can read published dishes" on public.menu_items;
create policy guest_dishes on public.menu_items for select to anon, authenticated using (
  published and exists(select 1 from public.menu_categories c where c.id = category and c.is_visible)
);
create policy guest_categories on public.menu_categories for select to anon, authenticated using (is_visible);
create policy guest_collections on public.special_collections for select to anon, authenticated using (is_visible);
create policy guest_collection_items on public.collection_items for select to anon, authenticated using (
  exists(select 1 from public.special_collections c where c.id = collection_id and c.is_visible)
  and exists(select 1 from public.menu_items d where d.id = item_id)
);
create policy guest_images on public.item_images for select to anon, authenticated using (
  exists(select 1 from public.menu_items d where d.id = item_id)
);
create policy guest_homepage on public.homepage_settings for select to anon, authenticated using (true);

do $$
declare table_name text;
begin
  foreach table_name in array array['menu_categories','menu_items','special_collections','collection_items','item_images','homepage_settings']
  loop
    execute format('alter table public.%I enable row level security',table_name);
    execute format('revoke all on public.%I from public, anon, authenticated',table_name);
    execute format('grant select on public.%I to anon, authenticated',table_name);
    execute format('grant insert, update, delete on public.%I to authenticated',table_name);
    execute format('create policy menu_admin_access on public.%I for all to authenticated using ((select public.is_menu_admin())) with check ((select public.is_menu_admin()))',table_name);
  end loop;
end $$;

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values ('menu-photos','menu-photos',true,1048576,array['image/webp']);
create policy menu_photo_admin on storage.objects for all to authenticated
using (bucket_id = 'menu-photos' and (select public.is_menu_admin()))
with check (bucket_id = 'menu-photos' and (select public.is_menu_admin()));
commit;
