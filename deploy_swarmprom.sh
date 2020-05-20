#!/bin/bash
#
# https://github.com/stefanprodan/swarmprom
# https://prometheus.io/docs/prometheus/latest/getting_started/
#

set -e


while read -r var;do
    export $var
done < <(grep -Ev '^#|^$' .env)

export STACK_NAME=swarmprom

# NOTE: If you forge the address and username of the mail sender, dest email server may reject the mail.
#export GF_SMTP_FROM_ADDRESS=admin@test.com 
#export GF_SMTP_FROM_NAME=admin


sed -i "s/traefik-public/$TRAEFIK_NETWORK/" swarmprom.yml
docker stack deploy -c swarmprom.yml $STACK_NAME


echo "Next access follows in browser:
https://grafana.$UI_DOMAIN
https://alertmanager.$UI_DOMAIN
https://unsee.$UI_DOMAIN
https://prometheus.$UI_DOMAIN
"
