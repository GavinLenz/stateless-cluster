#!/bin/bash
set -euo pipefail

NODES="de01 de02 de03"
BASE=~/Projects/stateless-cluster
LOG="$BASE/logs"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$LOG"

LOGFILE="$LOG/$TIMESTAMP.log"

echo "[INFO] $(date) starting node check" > "$LOGFILE"

for name in $NODES; do
    {
        echo "=== $name ==="

        if ssh -o ConnectTimeout=5 root@"$name" \
            "test -s /tmp/ubi.out && cat /tmp/ubi.out"; then
            echo "[INFO] $name OK"
        else
            echo "[ERROR] $name FAILED"
        fi

        echo
    } >> "$LOGFILE" 2>&1
done

echo "[INFO] $(date) completed node check" >> "$LOGFILE"

echo "Log written to $LOGFILE"