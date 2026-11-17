import { createClient } from '@supabase/supabase-js';

const { VITE_SUPABASE_URL: url, VITE_SUPABASE_PUBLISHABLE_KEY: key } = import.meta.env;
export const liveMenuEnabled = Boolean(url && key);
export const supabase = liveMenuEnabled ? createClient(url, key, {
  auth: { storageKey: 'spice-garden-admin-auth', detectSessionInUrl: false },
}) : null;

export async function checked(request) {
  const { data, error } = await request;
  if (error) throw Object.assign(new Error(error.message), { code: error.code });
  return data;
}

export const photos = () => supabase.storage.from('menu-photos');
export const photoUrl = (path) => photos().getPublicUrl(path).data.publicUrl;

export async function loadMenu(client = supabase) {
  const sorted = (table, id = 'id') => checked(client.from(table).select('*').order('sort_order').order(id));
  const [categories, items, collections, memberships, images, homepage] = await Promise.all([
    sorted('menu_categories'), sorted('menu_items'), sorted('special_collections'),
    sorted('collection_items', 'item_id'), sorted('item_images'),
    checked(client.from('homepage_settings').select('*').eq('id', 1).maybeSingle()),
  ]);
  return { categories, items, collections, memberships, images, homepage };
}

// Use a separate client without the staff session, even in the same browser.
export function loadGuestMenu() {
  return loadMenu(createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false, storageKey: 'spice-garden-guest' },
  }));
}

export function createRecoveryClient() {
  return createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false, storageKey: 'spice-garden-recovery' },
  });
}
