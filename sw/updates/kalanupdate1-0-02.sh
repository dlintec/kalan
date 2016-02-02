#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
sudo curl -L https://github.com/docker/compose/releases/download/1.6.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
if [[ -z $(grep "--iptables=false" /etc/default/docker) ]]; then 
  dkropt='"--dns 8.8.8.8 --dns 8.8.4.4 --iptables=false"'
  sudo sh -c "echo 'DOCKER_OPTS= $dkropt' >> /etc/default/docker"
fi
sudo service restart docker

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
if [[ -z $(grep " net/ipv4/ip_forward=1 " /etc/ufw/sysctl.conf) ]]; then 
  sudo sh -c "echo ' net/ipv4/ip_forward=1 ' >> /etc/ufw/sysctl.conf"
  sudo sh -c "echo 'net/ipv6/conf/default/forwarding=1' >> /etc/ufw/sysctl.conf"
  sudo sh -c "echo 'net/ipv6/conf/all/forwarding=1' >> /etc/ufw/sysctl.conf"
fi 
sudo ufw disable
sudo ufw enable
