dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > ~/kalan/src/installedpackages.fil
cat
#sudo apt-get autoremove

#to install back
#sudo dpkg --set-selections < list.txt
#sudo apt-get dselect-upgrade
#sudo apt-get autoremove
