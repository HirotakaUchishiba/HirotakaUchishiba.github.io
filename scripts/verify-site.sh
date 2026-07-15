#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT_DIR/MailWorker"

xmllint --html --noout "$ROOT_DIR/index.html" 2>/dev/null

for path in index.html privacy.html terms.html; do
    test -f "$SITE_DIR/$path"
    xmllint --html --noout "$SITE_DIR/$path" 2>/dev/null
done

test -f "$SITE_DIR/assets/site.css"
test -f "$SITE_DIR/assets/mailworker-icon.png"
test -f "$SITE_DIR/assets/mailworker-oauth-logo.png"

grep -qF 'href="MailWorker/"' "$ROOT_DIR/index.html"
grep -qF 'href="privacy.html"' "$SITE_DIR/index.html"
grep -qF 'Google API Services User Data Policy' "$SITE_DIR/privacy.html"
grep -qF 'Limited Use requirements' "$SITE_DIR/privacy.html"
grep -qF 'mailto:hirotaka1999821@gmail.com' "$SITE_DIR/privacy.html" "$SITE_DIR/terms.html"

oauth_logo_size="$(wc -c <"$SITE_DIR/assets/mailworker-oauth-logo.png")"
(( oauth_logo_size <= 1000000 ))
