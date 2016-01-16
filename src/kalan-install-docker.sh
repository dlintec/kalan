#!/bin/bash
#~/kalan/src/kalan-install-docker.sh
source ~/kalan/src/kalan-lib.sh
PACKAGE_MANAGER=$(get_package_manager)
sudo curl -sSL https://get.docker.com/ | sh
sudo $PACKAGE_MANAGER -y upgrade docker
sudo service docker start
#sudo systemctl enable docker
#sudo service docker enable
sudo curl -L https://github.com/docker/machine/releases/download/v0.5.3/docker-machine_linux-amd64 > docker-machine
sudo mv -f docker-machine /usr/local/bin/docker-machine
sudo chmod 751 /usr/local/bin/docker-machine
sudo curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo mv -f docker-compose /usr/local/bin/docker-compose
sudo chmod 751 /usr/local/bin/docker-compose
