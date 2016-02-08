#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
sudo service docker stop
echo "Installing/Updating Docker"
sudo apt-get -y install curl
source ~/kalan/src/kalan-lib.sh
PACKAGE_MANAGER=$(get_package_manager)
sudo curl -sSL https://get.docker.com/ | sh
sudo $PACKAGE_MANAGER -y upgrade docker
sudo service docker start
#sudo systemctl enable docker
#sudo service docker enable

sudo sh -c "curl -L https://github.com/docker/compose/releases/download/1.6.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod 751 /usr/local/bin/docker-compose
sudo chgrp docker /usr/local/bin/docker-compose 
sudo sh -c "curl -L https://github.com/docker/machine/releases/download/v0.6.0-rc2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine"
sudo chmod 751 /usr/local/bin/docker-machine
sudo chgrp docker /usr/local/bin/docker-machine 


if [[ -z $(grep " --iptables=false" /etc/default/docker) ]]; then 
   echo "adding to /etc/default/docker"
  dkropt='"--dns 8.8.8.8 --dns 8.8.4.4 --iptables=false"'
  sudo sh -c "echo 'DOCKER_OPTS=$dkropt' >> /etc/default/docker"
fi
sudo service restart docker

$KALAN_DIR/src/kconfigiptables.sh

