#!/bin/bash
clear

# podman kube play pod-dbm.yaml


# Get the absolute path of the directory where the script is located.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Run the podman command using the full path to the YAML file.
podman kube play "$SCRIPT_DIR/pod-dbm.yaml"

