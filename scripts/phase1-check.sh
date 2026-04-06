#!/usr/bin/env bash
set -euo pipefail

curl -I http://localhost:3000
docker compose ps
docker compose restart
docker compose ps
curl -I http://localhost:3000