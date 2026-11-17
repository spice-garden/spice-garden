import React, { useEffect, useState } from 'react';

let installEvent;
const installListeners = new Set();
function setInstallEvent(event) {
  installEvent = event;
  for (const notify of installListeners) notify(event);
}
window.addEventListener('beforeinstallprompt', (event) => {
  event.preventDefault();
  setInstallEvent(event);
});
window.addEventListener('appinstalled', () => setInstallEvent(undefined));

export function InstallPrompt() {
  const [prompt, setPrompt] = useState(installEvent);
  const [dismissed, setDismissed] = useState(() => sessionStorage.getItem('spice-install-dismissed') === '1');
  const ios = /iPhone|iPad|iPod/.test(navigator.userAgent) ||
    navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1;
  const standalone = window.matchMedia('(display-mode: standalone)').matches || navigator.standalone;

  useEffect(() => {
    installListeners.add(setPrompt);
    setPrompt(installEvent);
    return () => installListeners.delete(setPrompt);
  }, []);

  function dismiss() {
    sessionStorage.setItem('spice-install-dismissed', '1');
    setDismissed(true);
  }

  async function install() {
    if (!prompt) return;
    try { await prompt.prompt(); }
    finally { setInstallEvent(undefined); dismiss(); }
  }

  if (standalone || dismissed || (!prompt && !ios)) return null;
  return <aside className="install-banner" aria-label="Install Spice Garden">
    <img src="/icons/logo.png" alt="" width="36" height="36" />
    <div><strong>Install Spice Garden</strong>
      <p>{prompt ? 'Open the menu from your home screen.' : 'In Safari, tap Share, then Add to Home Screen.'}</p></div>
    {prompt && <button className="install-action" onClick={() => { void install().catch(console.error); }}>Install</button>}
    <button className="install-dismiss" onClick={dismiss} aria-label="Dismiss install suggestion">×</button>
  </aside>;
}
