#!/bin/bash
#Update 4: This update installs new docker version, installs meteor and creates new images for cantainerized meteor app. Also reconfigures firewall to forward docker's virtual network. 
sudo usermod -aG docker ${USER}
sudo usermod -aG sudo ${USER}
kalan-install-meteor
sudo service docker stop
kalan-install-docker
sudo service docker start
kalan-autostart
kalan-install-conky
echo "Finished"
