KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="/home/$KALAN_USER/kalan"
sudo apt-get install xfce4
if [[ ! -d $KALAN_DIR-data/downloads ]];then
    mkdir -p $KALAN_DIR-data/downloads
fi
cd $KALAN_DIR-data/downloads
wget https://atom-installer.github.com/v1.3.3/atom-amd64.deb
sudo dpkg -i atom-amd64.deb
#https://atom.io/
