#!/bin/bash
set -euo pipefail

BASE=~/Projects/stateless-cluster/snapshots
LATEST="$BASE/latest"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$BASE"

# If latest exists and is non-empty → archive it
if [ -d "$LATEST" ] && [ "$(find "$LATEST" -mindepth 1 -print -quit)" ]; then
    mv "$LATEST" "$BASE/$TIMESTAMP"
    echo "[INFO] Archived previous snapshot → $BASE/$TIMESTAMP"
fi

# Recreate latest
mkdir -p "$LATEST"

# Copy current system state
cp -a /etc/openchami/data/. "$LATEST"/

# Snapshot marker
echo "$TIMESTAMP" > "$LATEST/.snapshot"

# Retention: keep last 5 snapshots (excluding latest)
ls -dt "$BASE"/20* 2>/dev/null | tail -n +6 | xargs -r rm -rf

echo "[INFO] Latest snapshot updated."