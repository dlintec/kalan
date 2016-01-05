#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
PACKAGE_MANAGER=$(get_package_manager)
curl -sSL https://get.docker.com/ | sh
PACKAGE_MANAGER -y upgrade docker-engine
service docker start
systemctl enable docker
curl -L https://github.com/docker/machine/releases/download/v0.5.3/docker-machine_linux-amd64 >/usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine
curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
