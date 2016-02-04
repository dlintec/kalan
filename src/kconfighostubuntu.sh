KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
sudo useradd kalanhost
sudo usermod -aG docker kalanhost
sudo usermod -aG admin kalanhost
sudo usermod -aG sudo kalanhost
mkhomedir_helper kalanhost
usermod -s /bin/bash kalanhost

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
sudo sh -c "echo 'AllowUsers root kalanhost' >> /etc/ssh/sshd_config"
sudo ufw limit ssh
sudo apt-get -y install git
if [ ! -e $KALAN_DIR/README.md ];then
  git clone --recursive https://github.com/dlintec/kalan.git $KALAN_DIR
fi

cd $KALAN_DIR
git fetch --all
git reset --hard origin/master
git pull
chmod -R 770 $KALAN_DIR/src
chmod +x $KALAN_DIR/src/kalan.sh
chmod +x $KALAN_DIR/src/kregisterscript.sh
chmod +x $KALAN_DIR/src/kregisterscriptsfolder.sh
chmod -R 775 $KALAN_DIR/media

if [[ ! -d ~/bin ]];then
  mkdir -p ~/bin
fi
$KALAN_DIR/src/kregisterscriptsfolder.sh
mkdir -p $KALAN_DIR-data/provisions/kalan/data
mkdir -p $KALAN_DIR-data/provisions/kalan/images
mkdir -p $KALAN_DIR-data/provisions/kalan/logs

$KALAN_DIR/src/kalan-install-docker.sh

cd $KALAN_DIR/dockerfiles/kalan
docker-compose up -d 
