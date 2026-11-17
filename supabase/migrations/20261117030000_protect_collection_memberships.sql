begin;
alter table public.collection_items
  drop constraint collection_items_collection_id_fkey,
  add constraint collection_items_collection_id_fkey
    foreign key (collection_id) references public.special_collections(id) on delete restrict;
commit;
