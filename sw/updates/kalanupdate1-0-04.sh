#!/bin/bash
#Update 4: This update installs meteor and creates new images for cantainerized meteor app
sudo service docker stop
kalan-install-docker
sudo service docker start
kalan-autostart
echo "Finished"
