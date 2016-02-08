#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
if [[ -z $(grep " net/ipv4/ip_forward=1 " /etc/ufw/sysctl.conf) ]]; then 
  sudo sh -c  "echo ' net/ipv4/ip_forward=1 ' >> /etc/ufw/sysctl.conf"
  sudo sh -c "echo 'net/ipv6/conf/default/forwarding=1' >> /etc/ufw/sysctl.conf"
  sudo sh -c "echo 'net/ipv6/conf/all/forwarding=1' >> /etc/ufw/sysctl.conf"
fi 
newval='DEFAULT_FORWARD_POLICY="ACCEPT"'
replaceLinesThanContain 'DEFAULT_FORWARD_POLICY' "$newval" /etc/default/ufw sudo
sudo ufw disable
#sudo ufw allow in on docker0
sudo iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o docker0 -j ACCEPT
sudo sed -i s/DEFAULT_FORWARD_POLICY=\"DROP\"/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/ /etc/default/ufw
sudo iptables -t nat -A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE

sudo ufw enable
