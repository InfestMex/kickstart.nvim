#!/bin/bash
clear

# DO NOT USE THIS COMMAND, WILL CLEAR ALL VOLUMNES!!!!
# podman kube down --force pod-dbm.yaml

podman pod stop pod-dbm
podman pod rm pod-dbm
