function isMediaUrl(value) {
  return typeof value === 'string' && /^https:\/\//i.test(value);
}

export function dishMedia(item) {
  const gallery = Array.isArray(item.image_urls) ? item.image_urls : [];
  return {
    images: [...new Set([...gallery, item.image_url].filter(isMediaUrl))].slice(0, 4),
  };
}

export const keralaDate = new Intl.DateTimeFormat('sv-SE', { timeZone: 'Asia/Kolkata', year: 'numeric', month: '2-digit', day: '2-digit' });
export const isAvailable = (item) => Boolean(item) && item.is_available !== false;
export const isSpecial = (item, date) => item.special_on === date;
const money = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', minimumFractionDigits: 0, maximumFractionDigits: 2 });
export const formatPrice = (paise) => paise == null ? 'Ask staff' : money.format(paise / 100);

