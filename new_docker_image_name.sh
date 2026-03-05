#!/usr/bin/env bash
set -euo pipefail

# move to velox-testing directory (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# defaults
DEFAULT_OLD="velox-adapters-build:latest"
DEFAULT_NEW="velox-adapters-build:lhvu"

# arguments (optional)
OLD="${1:-$DEFAULT_OLD}"
NEW="${2:-$DEFAULT_NEW}"

FILES=(
  velox/docker/docker-compose.adapters.build.yml
  velox/docker/docker-compose.adapters.build.sccache.yml
  velox/docker/docker-compose.adapters.benchmark.yml
  velox/scripts/benchmark_velox.sh
)

echo "Repo root: $PWD"
echo "Old image: $OLD"
echo "New image: $NEW"
echo

echo "Preview matches:"
grep -R --line-number "$OLD" velox/docker velox/scripts || true
echo

# replace
sed -i "s|$OLD|$NEW|g" "${FILES[@]}"

echo "Verification:"
grep -R --line-number "$NEW" velox/docker velox/scripts || true
echo

git -C velox diff
