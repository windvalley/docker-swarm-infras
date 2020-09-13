#!/bin/bash
# deploy all

set -e


ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$ROOT_DIR" || exit 1

echo "Start deploying Traefik ..."
./deploy_traefik.sh

echo "Start deploying Registry ..."
./deploy_registry.sh

echo "Start deploying Swarmprom ..."
./deploy_swarmprom.sh

echo "Start deploying Swarmpit ..."
./deploy_swarmpit.sh

echo "Start deploying Portainer ..."
./deploy_portainer.sh
