import React, { useState } from 'react';

export function PasswordField({ label, name, autoComplete, minLength }) {
  const [visible, setVisible] = useState(false);
  return <div className="password-field">
    <label>{label}<input name={name} type={visible ? 'text' : 'password'}
      autoComplete={autoComplete} minLength={minLength} required /></label>
    <button type="button" aria-label={`${visible ? 'Hide' : 'Show'} ${label.toLowerCase()}`}
      onClick={() => setVisible(!visible)}>
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" aria-hidden="true">
        <path d="M2 12s3.6-6 10-6 10 6 10 6-3.6 6-10 6-10-6-10-6Z" /><circle cx="12" cy="12" r="2.5" />
        {visible && <path d="m3 3 18 18" />}
      </svg>
    </button>
  </div>;
}
