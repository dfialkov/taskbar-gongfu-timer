#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

VERSION="${1:?Usage: scripts/release.sh <version> (e.g. 1.0.0)}"
ZIP="GongfuTimer-${VERSION}.zip"

# Build the app
scripts/build.sh

# Create release zip
echo "Creating $ZIP..."
ditto -c -k --keepParent GongfuTimer.app "$ZIP"

SHA=$(shasum -a 256 "$ZIP" | cut -d' ' -f1)

echo ""
echo "Release artifact: $ZIP ($(du -h "$ZIP" | cut -f1))"
echo "SHA-256: $SHA"
echo ""
echo "Next steps:"
echo "  1. Create a GitHub release: gh release create v${VERSION} ${ZIP} --title \"v${VERSION}\""
echo "  2. Update your Cask formula with the new version and SHA-256"
