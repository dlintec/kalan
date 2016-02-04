#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh

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

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
if [[ -z $(grep " net/ipv4/ip_forward=1 " /etc/ufw/sysctl.conf) ]]; then 
  sudo sh -c  "echo ' net/ipv4/ip_forward=1 ' >> /etc/ufw/sysctl.conf"
  sudo sh -c "echo 'net/ipv6/conf/default/forwarding=1' >> /etc/ufw/sysctl.conf"
  sudo sh -c "echo 'net/ipv6/conf/all/forwarding=1' >> /etc/ufw/sysctl.conf"
fi 
newval='DEFAULT_FORWARD_POLICY="ACCEPT"'
replaceLinesThanContain 'DEFAULT_FORWARD_POLICY' "$newval" /etc/default/ufw sudo

sudo iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o docker0 -j ACCEPT
sudo ufw disable
#sudo ufw allow in on docker0
sudo sed -i s/DEFAULT_FORWARD_POLICY=\"DROP\"/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/ /etc/default/ufw
sudo iptables -t nat -A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE
sudo ufw enable
