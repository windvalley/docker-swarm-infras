Name
====

`docker-swarm-infras`  -  Docker Swarm Mode Infrastructrues Setup.


Description
===========

Integrated Traefik、Consul、Prometheus、Grafana、Swarmpit、Portainer and some other useful open source products
into the Docker Swarm Mode cluster selectively by some shell scripts and docker-compose files, 
and then setup a productively container cloud platform.


Deployment
==========

## Swarm mode cluster

Create Swarm mode cluster first refer to:
```
https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/
```

## Traefik & Consul

Set up Traefik as a glabal load balancer/proxy and Consul to store configurations and HTTPS certificates.

### Deploy traefik-consul stack in one manager node

```bash
./deploy_traefik.sh
```

Then execute some commands to check:
```bash
# all nodes in swarm mode cluster
docker node ls

# all stacks in swarm mode cluster
docker stack ls

# all services in swarm mode cluster
docker service ls

# services in one stack
docker stack services traefik-consul

# tasks in one stack
docker stack ps traefik-consul

# tasks in one service
docker service ps traefik-consul_traefik

# tasks in someone node
docker node ps self/node_id/node_hostname

# logs of a service
docker service logs traefik-consul_traefik -f

# logs of a task/container
docker container logs traefik-consul_traefik.2.8bn0pn4jg2c0y2bu94sftj12l
```

Relevant destroy commands:
```bash
# destroy a stack
docker stack rm traefik-consul

# destroy a service
docker service rm traefik-consul_traefik

# destroy a task/container will have no effect in actual,
# cos the task/container will auto startup immediately.
docker container rm -f traefik-consul_traefik.2.8bn0pn4jg2c0y2bu94sftj12l
```

If traefik.yml or .env variables have been changed, just execute the shell script again,
and the stack will be updated automaticly:
```
./depoly_traefik.sh
```

### Put your domain cert and key into Consul

```bash
# cert
docker container exec -it traefik-consul_consul-leader... consul kv put traefik/tls/certificates/wildcard.$UI_DOMAIN/certFile  "your cert content"
# key
docker container exec -it traefik-consul_consul-leader... consul kv put traefik/tls/certificates/wildcard.$UI_DOMAIN/keyFile  "your key content"
```

> https://www.consul.io/docs/commands/kv

### Browser
```
https://traefik.$UI_DOMAIN
https://consul.$UI_DOMAIN
```

## Registry

Simple private image registry.

### Deploy

```bash
./deploy_registry.sh
```

### Browser
```
https://reg.$UI_DOMAIN/v2/
```

## Swarmprom (Prometheus & Grafana & Unsee & Alertmanager)

Swarmprom is actually just a set of tools pre-configured in a smart way for a Docker Swarm cluster.

### Deploy

```bash
./deploy_swarmprom.sh
```

### Browser
```
https://grafana.$UI_DOMAIN
https://alertmanager.$UI_DOMAIN
https://unsee.$UI_DOMAIN
https://prometheus.$UI_DOMAIN
```

## Swarmpit

Swarmpit provides a nice and clean way to manage your Docker Swarm cluster.

### Depoly

```bash
./deploy_swarmpit.sh
```

### Browser
```
https://swarmpit.$UI_DOMAIN
```

## Portainer

Portainer is a web UI (user interface) that allows you to see the state of your Docker services in a Docker Swarm mode cluster and manage it.

### Deploy

```bash
./deploy_portainer.sh
```

### Browser
```
https://portainer.$UI_DOMAIN
```

References
==========

https://dockerswarm.rocks/

https://docs.traefik.io/

https://github.com/stefanprodan/swarmprom

https://github.com/swarmpit/swarmpit

https://github.com/portainer/portainer
