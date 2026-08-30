#!/bin/bash
# Starts the aerophys server and follows its logs.
# Ctrl-C here only stops watching logs — it does NOT stop the server.
# To stop the server: docker compose stop mc (from this directory).
set -euo pipefail
cd "$(dirname "$0")"
docker compose up -d mc
docker compose logs -f mc
