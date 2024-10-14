#!/bin/env bash

ROOT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

podman run -it --rm \
  -v matrix-xmpp-appservice-development-matrix-data:/data:Z \
  -e SYNAPSE_SERVER_NAME=localhost \
  -e SYNAPSE_REPORT_STATS=no \
  docker.io/matrixdotorg/synapse:latest generate

podman run -it --rm \
  -v matrix-xmpp-appservice-development-matrix-data:/data:Z \
  -p 8008:8008 \
  docker.io/matrixdotorg/synapse:latest
