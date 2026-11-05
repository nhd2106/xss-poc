(async () => {
  const el = document.getElementById('out');
  const line = (k, v) => (el.textContent += `\n${k}: ${v}`);
  line('origin', location.origin);
  line('document.cookie', JSON.stringify(document.cookie));
  for (const p of ['/api/user/permissions', '/api/user/list']) {
    const r = await fetch(p, { credentials: 'include' });
    const b = await r.text();
    line(p, `${r.status} (${b.length}B) ${b.slice(0, 140).replace(/\s+/g, ' ')}`);
  }
})();