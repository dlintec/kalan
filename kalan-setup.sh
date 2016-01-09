main() {
# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i
# curl -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i
KALAN_VERSION="2.0.0"


PARAMETRO="$1"

KALAN_USER="$(who am i | awk '{print $1}')"
echo "Usuario :$KALAN_USER"

current_dir=`pwd`
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
PACKAGE_MANAGER="yum"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PACKAGE_MANAGER=${osInfo[$f]}
        echo $PACKAGE_MANAGER
    fi
done
#$PACKAGE_MANAGER -y install git curl
export PACKAGE_MANAGER
if ! [ -x "$(command -v dfgdfg)" ]; then
  echo 'git is not installed.' >&2
  exit
fi
if [ ! -e ~/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git ~/kalan
fi
cd ~/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x ~/kalan/kalan-setup.sh
chmod -R 770 ~/kalan/src
chmod +x ~/kalan/src/kalan.sh
chmod +x ~/kalan/src/kalan-update.sh
chmod +x ~/kalan/src/kregisterscript.sh
chmod +x ~/kalan/src/kregisterscriptsfolder.sh
source ~/kalan/src/kalan-lib.sh

function f_create_scripts {

echo "Creando scripts"
echo "-------------------------------------------------------------------------"
if [ ! -d ~/kalan/src/ ]; then
    mkdir -p ~/kalan/src/
fi
if [ ! -d ~/kalan/bin/ ]; then
    mkdir -p ~/kalan/bin/
fi
if [ ! -d ~/kalan/src/ ]; then
    mkdir -p ~/kalan/src/
fi
if [ ! -d ~/kalan/standard/ ]; then
    mkdir -p ~/kalan/standard/
fi
if [ ! -d ~/kalan-data/conf/ ]; then
    mkdir -p ~/kalan-data/conf/
fi

if [ ! -d ~/kalan/src/ ]; then
    mkdir -p ~/kalan/src/
fi

chmod -R 770 ~/kalan/src
chmod +x ~/kalan/src/kalan.sh
chmod +x ~/kalan/src/kalan-update.sh
chmod +x ~/kalan/src/kregisterscript.sh
chmod +x ~/kalan/src/kregisterscriptsfolder.sh
cd ~/kalan/src/
./kregisterscriptsfolder.sh

export PATH=$PATH:$HOME/kalan/bin
}

f_create_scripts
cd $current_dir

}

main "$@"
