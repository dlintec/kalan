#!/bin/bash
echo "installing meteor..."
sudo apt-get -y install npm curl

curl https://install.meteor.com/ | sh
#curl http://www.meteorkitchen.com/install | /bin/sh
sudo ln -fs "$(which nodejs)" /usr/bin/node
sudo npm install npm -g
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm install -g orion-cli
sudo ln -sf /usr/local/n/versions/node/5.4.1/bin/node /usr/bin/node 

sudo add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make
sudo apt-get update
sudo apt-get install --yes lib32z1 lib32stdc++6

sudo apt-get install -y ubuntu-make

umake android
