#!/usr/bin/env bash
set -euo pipefail

# Go to the directory containing this script (velox-testing)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

OLD="velox-adapters-build:latest"
DEFAULT_NEW="velox-adapters-build:lhvu"
NEW="${1:-$DEFAULT_NEW}"

echo "Old image: $OLD"
echo "New image: $NEW"
echo "Repo root: $PWD"
echo "Updating under: velox/docker and velox/scripts"
echo

# preview what will change
grep -R --line-number "$OLD" velox/docker velox/scripts || true

# replace in-place
sed -i "s|$OLD|$NEW|g" \
	  velox/docker/docker-compose.adapters.build.yml \
	    velox/docker/docker-compose.adapters.build.sccache.yml \
	      velox/docker/docker-compose.adapters.benchmark.yml \
	        velox/scripts/benchmark_velox.sh

# verify
grep -R --line-number "$NEW" velox/docker velox/scripts || true

git -C velox diff
