#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Build
bash scripts/build.sh

# Kill existing instance if running
if pkill -x GongfuTimer 2>/dev/null; then
    sleep 1
fi

# Start
open GongfuTimer.app
