parchivo="$1"
if [[ -n "$parchivo"]];then
    parchivo="installedpackages"
fi
dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > ~/kalan-data/$parchivo.fil
ls /var/cache/apt/archives > ~/kalan-data/$parchivo-cached.fil
#sudo apt-get autoremove

#to install back
#sudo dpkg --set-selections < list.txt
#sudo apt-get dselect-upgrade
#sudo apt-get autoremove
