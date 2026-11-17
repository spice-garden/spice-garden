import React, { useEffect, useState } from 'react';
import { formatPrice, isAvailable } from './menu.js';
import { Modal } from './Dining.jsx';
import './plate.css';

export function usePlate(tableLabel) {
  const key = `spice-garden:plate:v1:${tableLabel ?? 'menu'}`;
  const [quantities, setQuantities] = useState(() => {
    try {
      return new Map(JSON.parse(localStorage.getItem(key) ?? '[]').filter(([id, qty]) =>
        typeof id === 'string' && Number.isInteger(qty) && qty > 0 && qty <= 99));
    } catch { return new Map(); }
  });
  useEffect(() => {
    try { localStorage.setItem(key, JSON.stringify([...quantities])); }
    catch { /* Keep selections in memory when browser storage is unavailable. */ }
  }, [key, quantities]);
  function change(item, delta) {
    if (delta > 0 && !isAvailable(item)) return;
    setQuantities((previous) => {
      const next = new Map(previous);
      const qty = Math.min(99, (next.get(item.id) ?? 0) + delta);
      if (qty > 0) next.set(item.id, qty);
      else next.delete(item.id);
      return next;
    });
  }
  return { quantities, change };
}

export function PlateButton({ item, plate }) {
  const quantity = plate.quantities.get(item.id) ?? 0;
  const available = isAvailable(item);
  if (!quantity) return available ? <button className="plate-add" aria-label={`Add ${item.name} to My Plate`}
    onClick={() => plate.change(item, 1)}>+ Add</button> : null;
  return <div className="plate-stepper" aria-label={`${item.name} quantity`}>
    <button aria-label={`Remove one ${item.name}`} onClick={() => plate.change(item, -1)}>−</button>
    <output>{quantity}</output>
    <button aria-label={`Add one ${item.name}`} disabled={!available || quantity >= 99} onClick={() => plate.change(item, 1)}>+</button>
  </div>;
}

export function Plate({ plate, items, tableLabel }) {
  const [open, setOpen] = useState(false);
  const rows = [...plate.quantities].map(([id, quantity]) => ({
    item: items.find((item) => item.id === id) ?? { id, name: 'Dish no longer listed', is_available: false }, quantity,
  }));
  const count = rows.reduce((sum, row) => sum + row.quantity, 0);
  const subtotal = rows.reduce((sum, { item, quantity }) => sum + (isAvailable(item) ? (item.price_paise ?? 0) * quantity : 0), 0);
  const unknownPrices = rows.some(({ item }) => isAvailable(item) && item.price_paise == null);
  const unavailable = rows.some(({ item }) => !isAvailable(item));
  return <>
    {count > 0 && <div className="plate-bar">
      <button className="plate-trigger" onClick={() => setOpen(true)}>
        <span>My Plate · {count} {count === 1 ? 'item' : 'items'}</span><strong>Show waiter</strong>
      </button>
    </div>}
    {open && <Modal titleId="plate-title" className="plate-modal" onDismiss={() => setOpen(false)}>
      <div className="dish-intro">
        <h2 id="plate-title">My Plate</h2>
        {tableLabel && <p>Table {tableLabel}</p>}
      </div>
      <div className="plate-summary">
        {rows.length ? <ul>{rows.map(({ item, quantity }) => <li key={item.id}>
          <div><strong>{item.name}</strong>
            <p>{isAvailable(item) ? `${quantity} × ${formatPrice(item.price_paise)}` : 'Unavailable'}</p>
            {isAvailable(item) && item.price_paise != null && <p>{formatPrice(quantity * item.price_paise)}</p>}
          </div>
          <PlateButton item={item} plate={plate} />
        </li>)}</ul> : <p>Your plate is empty.</p>}
        <p className="plate-total"><strong>Base-price subtotal{unknownPrices ? ' for priced dishes' : ''}</strong> {formatPrice(subtotal)}</p>
        {unavailable && <p>Unavailable dishes are excluded from the subtotal.</p>}
        <p>Prices shown are base prices. Any applicable taxes and charges will be added to the final bill.</p>
        {rows.length > 0 && <p>Show this screen to your waiter.</p>}
      </div>
    </Modal>}
  </>;
}
