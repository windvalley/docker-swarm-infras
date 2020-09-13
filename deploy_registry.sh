#!/bin/bash
#

set -e


IFS=$'\n'
while read -r var;do
    # shellcheck disable=SC2163
    export "$var"
done < <(grep -Ev '^#|^$' .env)


export STACK_NAME=registry
# shellcheck disable=SC2155
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')


docker node update --label-add ${STACK_NAME}.image-data=true "$NODE_ID"

sed -i "s/traefik-public/$TRAEFIK_NETWORK/" registry.yml
docker stack deploy -c registry.yml $STACK_NAME


echo "Next access follows in browser:
https://reg.$UI_DOMAIN/v2
"
