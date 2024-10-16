#!/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# generate base config
echo " - Generating synapse base config"
podman run -it --rm \
  -v matrix-xmpp-appservice-development-matrix:/data:Z \
  -e SYNAPSE_SERVER_NAME=localhost \
  -e SYNAPSE_REPORT_STATS=no \
  docker.io/matrixdotorg/synapse:latest generate

# update config to use postgres
echo " - Patching synapse config for postgres"
podman run -it --rm \
  -v matrix-xmpp-appservice-development-matrix:/data:Z \
  -u 991:991 \
  docker.io/mikefarah/yq:latest -i 'del(.database) |
    .database.name = "psycopg2" |
    .database.txn_limit = 10000 |
    .database.args.user = "postgres" |
    .database.args.password = "password" |
    .database.args.dbname = "synapse" |
    .database.args.host = "127.0.0.1" |
    .database.args.port = 5432 |
    .database.args.cp_min = 5 |
    .database.args.cp_max = 10' /data/homeserver.yaml

# start postgres and synapse
echo " - Starting postgres and synapse pod"
podman kube play --replace $SCRIPTS_DIR/development-containers.yaml
podman pod logs -f matrix-xmpp-appservice-development

