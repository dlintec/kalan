#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
kalan-install-docker
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
sudo ufw enable
