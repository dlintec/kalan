#!/bin/bash
echo "installing meteor..."
sudo apt-get -y install npm curl

curl https://install.meteor.com/ | sh
#curl http://www.meteorkitchen.com/install | /bin/sh
sudo npm install npm -g 
sudo npm cache clean -f  
sudo npm install -g n 
sudo n stable 
sudo npm install -g orion-cli
sudo npm install -g iron-meteor
sudo ln -sf /usr/local/n/versions/node/$(ls /usr/local/n/versions/node)/bin/node /usr/bin/node


sudo add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make
sudo apt-get update
sudo apt-get install --yes lib32z1 lib32stdc++6

sudo apt-get install -y ubuntu-make
if [[ -z $(grep "ANDROID_HOME" ~/.bashrc) ]]; then 
   echo "ANDROID_HOME=~/Android/Sdk" >> ~/.bashrc
   echo "export PATH=$PATH:~/Android/Sdk/tools:~/Android/Sdk/platform-tools"  >> ~/.bashrc
   echo "Adding path"
fi
umake android
