#!/bin/bash

set -e


export \
STACK_NAME=traefik-consul \
# consul服务的的副本数, 默认是3(建议是3或5, 不要更多了),
# 如果swarm mode只有一个节点, 需要设置成0.
CONSUL_REPLICAS=3 \
# 设置traefik的副本数, 默认是3, 如果只有一个节点需要设置成1,
TRAEFIK_REPLICAS=3 \
# 获取当前所在的manager节点ID
NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

while read -r var;do
    export $var
done < <(grep -Ev '^#|^$' .env)


docker network create --driver=overlay $TRAEFIK_NETWORK

docker node update --label-add ${STACK_NAME}.consul-data-leader=true $NODE_ID

sed -i "s/traefik-public/$TRAEFIK_NETWORK/" traefik.yml
docker stack deploy -c traefik.yml $STACK_NAME


echo "Next please put your domain certs in consul as follows:
docker container exec -it traefik-consul_consul-leader... consul kv put traefik/tls/certificates/yourdomain/certFile  "your cert content"
docker container exec -it traefik-consul_consul-leader... consul kv put traefik/tls/certificates/yourdomain/keyFile  "your key content"

Then access follows in browser:
https://traefik.your-base-domain
https://consul.your-base-domain
"
