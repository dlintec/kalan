#!/bin/bash
sudo apt-get -y install npm curl

curl https://install.meteor.com/ | sh
#curl http://www.meteorkitchen.com/install | /bin/sh
sudo npm install npm -g
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm install -g orion-cli
sudo ln -sf /usr/local/n/versions/node/5.4.1/bin/node /usr/bin/node 


