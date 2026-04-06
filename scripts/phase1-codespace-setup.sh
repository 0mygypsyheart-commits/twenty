#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f .env ]]; then
  if [[ ! -f .env.example ]]; then
    echo ".env.example is missing in $ROOT_DIR" >&2
    exit 1
  fi

  cp .env.example .env
fi

if grep -q '^APP_SECRET=replace_me_with_a_random_string$' .env; then
  if command -v openssl >/dev/null 2>&1; then
    APP_SECRET_VALUE="$(openssl rand -base64 32 | tr -d '\n')"
  else
    APP_SECRET_VALUE="$(python3 - <<'PY'
import secrets
print(secrets.token_urlsafe(32))
PY
)"
  fi
  sed -i "s|^APP_SECRET=.*|APP_SECRET=${APP_SECRET_VALUE}|" .env
fi

docker compose up -d
docker compose ps