#!/bin/bash
# Verify packages are up to date
parametro="$1"
# Install required packages

#httpd httpd-devel mod_ssl
#kernel-devel
#firewalld
echo "------------------------- kalan-core-apt-get----------------------------"
echo "parametro: $parametro"
if [ "$parametro" != "postinstall" ]; then
   apt-get -y update
   apt-get -y install $(cat /var/kalan/sw/kalan-core-apt-get.fil)
   echo "INSTALLED:kalan-core-apt-get" > /var/kalan-data/conf/flag_install
fi
