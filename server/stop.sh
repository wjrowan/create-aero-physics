#!/bin/bash
# Stops the aerophys server. Can take up to 5 minutes (stop_grace_period) —
# the world needs to finish saving. Do not interrupt this.
set -euo pipefail
cd "$(dirname "$0")"
echo "Stopping aerophys-mc — this can take up to 5 minutes while the world saves..."
docker compose stop mc
