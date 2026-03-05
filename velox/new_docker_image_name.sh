cd $HOME/projects/velox-dev/velox-testing/velox

OLD='velox-adapters-build:latest'
NEW='velox-adapters-build:lhvu'

# preview what will change
grep -R --line-number "$OLD" docker scripts

# replace in-place
sed -i "s|$OLD|$NEW|g" \
	  docker/docker-compose.adapters.build.yml \
	    docker/docker-compose.adapters.build.sccache.yml \
	      docker/docker-compose.adapters.benchmark.yml \
	        scripts/benchmark_velox.sh

# verify
grep -R --line-number "$NEW" docker scripts
git diff
