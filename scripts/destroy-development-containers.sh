#!/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo " - Removing pod"
podman kube down $SCRIPTS_DIR/development-containers.yaml

echo " - Removing volumes"
podman volume rm matrix-xmpp-appservice-development-matrix
podman volume rm matrix-xmpp-appservice-development-postgres
