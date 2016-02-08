#!/bin/bash
#Update 4: This update installs new docker version, installs meteor and creates new images for cantainerized meteor app. Also reconfigures firewall to forward docker's virtual network. 
kalan-install-meteor
kalan-install-conky
sudo service docker stop
kalan-install-docker
sudo service docker start
kalan-autostart
echo "Finished"
