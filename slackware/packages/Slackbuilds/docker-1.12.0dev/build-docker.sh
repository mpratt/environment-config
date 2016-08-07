#!/bin/sh
# Build everything we need for docker

CWD=$(pwd)
SLACKBUILDS=( 'runc/runc.SlackBuild' 'containerd/containerd.SlackBuild' 'docker/docker.SlackBuild' 'docker-compose/docker-compose.SlackBuild')
[[ "$(whoami)" != "root" ]] && echo "You need to be root in order to run this script" && exit 1
for package in ${SLACKBUILDS[@]}; do
    cd ${CWD}/$(dirname ${package})
    echo "Building $(basename ${package})"
    bash $(basename ${package})
    upgradepkg --install-new --reinstall /tmp/$(basename ${package} | sed 's/\.SlackBuild//g')*.t?z
done
