/* SettleMate cross-device enhancements. No account data leaves this device. */
(() => {
  'use strict';
  const root = document.documentElement;
  const classify = () => {
    const width = window.innerWidth;
    const type = width < 600 ? 'mobile' : width < 900 ? 'tablet' : 'desktop';
    root.dataset.platform = type;
    root.dataset.displayMode = matchMedia('(display-mode: standalone)').matches ? 'installed' : 'browser';
  };
  classify();
  window.addEventListener('resize', classify, {passive:true});
  window.addEventListener('orientationchange', classify, {passive:true});

  let installPrompt = null;
  window.addEventListener('beforeinstallprompt', event => {
    event.preventDefault();
    installPrompt = event;
    const status = document.querySelector('.status');
    if (!status || document.getElementById('installApp')) return;
    const button = document.createElement('button');
    button.id = 'installApp';
    button.type = 'button';
    button.textContent = 'Install app';
    button.setAttribute('aria-label', 'Install SettleMate on this device');
    button.style.cssText = 'border:0;border-radius:999px;padding:5px 10px;background:var(--coral);color:white;font-weight:700;font-size:12px';
    status.append(button);
    button.addEventListener('click', async () => {
      if (!installPrompt) return;
      installPrompt.prompt();
      await installPrompt.userChoice;
      installPrompt = null;
      button.remove();
    });
  });
  window.addEventListener('appinstalled', () => {
    const button = document.getElementById('installApp');
    if (button) button.remove();
    root.dataset.displayMode = 'installed';
  });

  document.addEventListener('keydown', event => {
    if (event.altKey && /^[1-6]$/.test(event.key) && !event.target.matches('input,textarea,select,[contenteditable="true"]')) {
      const buttons = [...document.querySelectorAll('#nav button')];
      const target = buttons[Number(event.key)-1];
      if (target) { event.preventDefault(); target.click(); }
    }
    if (event.key === 'Escape') {
      const sheet = document.getElementById('sheet');
      if (sheet) sheet.classList.remove('open');
    }
    if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k' && !event.target.matches('input,textarea,select,[contenteditable="true"]')) {
      const fab = document.getElementById('fab');
      if (fab) { event.preventDefault(); fab.click(); }
    }
  });
})();
