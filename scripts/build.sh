#!/bin/bash
set -euo pipefail

CONFIG=${1:-}

if [ -z "$CONFIG" ]; then
    echo "[ERROR] Path to image config required"
    exit 1
fi

if [ ! -f "$CONFIG" ]; then
    echo "[ERROR] Config file does not exist: $CONFIG"
    exit 1
fi

# Load S3 credentials if not already set
if [ -z "${ROOT_ACCESS_KEY:-}" ] || [ -z "${ROOT_SECRET_KEY:-}" ]; then
    echo "[INFO] Loading S3 credentials..."
    source <(sudo cat /etc/versitygw/secrets.env)
fi

if [ -z "${ROOT_ACCESS_KEY:-}" ] || [ -z "${ROOT_SECRET_KEY:-}" ]; then
    echo "[ERROR] S3 credentials not available"
    exit 1
fi

echo "[INFO] Building image from $CONFIG..."

podman run \
    --rm \
    --device /dev/fuse \
    -e S3_ACCESS="${ROOT_ACCESS_KEY}" \
    -e S3_SECRET="${ROOT_SECRET_KEY}" \
    -v "$(realpath "$CONFIG")":/home/builder/config.yaml:Z \
    ghcr.io/openchami/image-build-el9:v0.1.2 \
    image-build \
        --config config.yaml \
        --log-level INFO

echo "[INFO] Image build complete."