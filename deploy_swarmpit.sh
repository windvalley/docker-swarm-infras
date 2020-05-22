#!/bin/bash
#

set -e


IFS=$'\n'
while read -r var;do
    export $var
done < <(grep -Ev '^#|^$' .env)


export STACK_NAME=swarmpit
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')


docker node update --label-add swarmpit.db-data=true $NODE_ID
docker node update --label-add swarmpit.influx-data=true $NODE_ID

sed -i "s/traefik-public/$TRAEFIK_NETWORK/" swarmpit.yml
docker stack deploy -c swarmpit.yml $STACK_NAME


echo "Next access follows in browser:
https://swarmpit.$UI_DOMAIN
"
