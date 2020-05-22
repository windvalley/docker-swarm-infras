#!/bin/bash
#

set -e


IFS=$'\n'
while read -r var;do
    export $var
done < <(grep -Ev '^#|^$' .env)


export STACK_NAME=portainer
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')


docker node update --label-add $STACK_NAME.portainer-data=true $NODE_ID

sed -i "s/traefik-public/$TRAEFIK_NETWORK/" portainer.yml
docker stack deploy -c portainer.yml $STACK_NAME


echo "Next access follows in browser:
https://portainer.$UI_DOMAIN
"
