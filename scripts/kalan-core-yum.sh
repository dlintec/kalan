#!/bin/bash
# Verify packages are up to date
parametro="$1"
# Install required packages

#httpd httpd-devel mod_ssl
#kernel-devel
#firewalld
echo "------------------------- kalan-core-yum----------------------------"
echo "parametro: $parametro"
if [ "$parametro" != "postinstall" ]; then
   yum -y update
   yum install -y epel-release
   yum -y upgrade
   yum -y install $(cat /opt/kalan/sw/kalan-core-yum.fil)
   echo "INSTALLED:kalan-core-yum" > /opt/kalan-data/conf/flag_install
fi
