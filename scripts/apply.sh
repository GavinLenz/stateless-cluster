#!/bin/bash
set -euo pipefail

BASE=~/Projects/stateless-cluster
SRC="$BASE/desired-state"
DST="/etc/openchami/data"
SNAPSHOT="$BASE/scripts/snapshot.sh"

echo "[INFO] Applying OpenCHAMI config..."

# Validate source
if [ ! -d "$SRC" ]; then
    echo "[ERROR] Source config directory not found: $SRC"
    exit 1
fi

if [ -z "$(ls -A "$SRC")" ]; then
    echo "[ERROR] Source config is empty. Aborting."
    exit 1
fi

# Snapshot current state
if [ -x "$SNAPSHOT" ]; then
    "$SNAPSHOT"
else
    echo "[WARN] Snapshot script missing or not executable, skipping"
fi

# Apply config to filesystem
echo "[INFO] Syncing desired-state → /etc/openchami/data"
sudo rsync -av --delete "$SRC"/ "$DST"/

# Refresh token (required for ochami CLI)
echo "[INFO] Refreshing OpenCHAMI token"
export DEMO_ACCESS_TOKEN=$(sudo bash -lc 'gen_access_token')

# Apply cloud-init defaults
if [ -f "$DST/cloud-init/defaults.yaml" ]; then
    echo "[INFO] Updating cloud-init defaults"
    ochami cloud-init defaults set -f yaml \
      -d @"$DST/cloud-init/defaults.yaml"
else
    echo "[WARN] defaults.yaml not found, skipping"
fi

# Apply cloud-init compute group
if [ -f "$DST/cloud-init/compute.yaml" ]; then
    echo "[INFO] Updating cloud-init compute group"
    ochami cloud-init group set -f yaml \
      -d @"$DST/cloud-init/compute.yaml"
else
    echo "[WARN] compute.yaml not found, skipping"
fi

echo "[INFO] Done."