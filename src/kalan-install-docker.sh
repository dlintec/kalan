#!/bin/bash
#~/kalan/src/kalan-install-docker.sh
sudo apt-get -y install curl
source ~/kalan/src/kalan-lib.sh
PACKAGE_MANAGER=$(get_package_manager)
sudo curl -sSL https://get.docker.com/ | sh
sudo $PACKAGE_MANAGER -y upgrade docker
sudo service docker start
#sudo systemctl enable docker
#sudo service docker enable

sudo curl -L https://github.com/docker/compose/releases/download/1.6.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod 751 /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/machine/releases/download/v0.6.0-rc2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
sudo chmod 751 /usr/local/bin/docker-machine
