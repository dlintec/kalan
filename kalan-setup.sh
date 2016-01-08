main() {
# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i

PARAMETRO="$1"

export KALAN_USER=$(who am i | awk '{print $1}')
export KALAN_VERSION="2.0.0"
echo "Usuario :$KALAN_USER"
if [[ $EUID -ne 0 ]]; then
  echo "You must have root powers to install" 2>&1
  exit 1
else


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
$PACKAGE_MANAGER -y install git curl wget dialog whiptail
export PACKAGE_MANAGER
if [ ! -e ~/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git ~/kalan
fi
cd ~/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x ~/kalan/kalan-setup.sh
chmod -R 770 ~/kalan/scripts
chmod +x ~/kalan/scripts/kalan.sh
chmod +x ~/kalan/scripts/kalan-update.sh
chmod +x ~/kalan/scripts/kregisterscript.sh
chmod +x ~/kalan/scripts/kregisterscriptsfolder.sh
source ~/kalan/scripts/kalan-lib.sh

function f_create_scripts {

echo "Creando scripts"
echo "-------------------------------------------------------------------------"
if [ ! -d ~/kalan/scripts/ ]; then
    mkdir -p ~/kalan/scripts/
fi
if [ ! -d ~/kalan/sw/ ]; then
    mkdir -p ~/kalan/sw/
fi
if [ ! -d ~/kalan/standard/ ]; then
    mkdir -p ~/kalan/standard/
fi
if [ ! -d ~/kalan-data/conf/ ]; then
    mkdir -p ~/kalan-data/conf/
fi
if [ ! -d "/var/web-apps" ]; then
    mkdir -p /var/web-apps
    chmod -R 775 /var/web-apps
fi
if [ ! -d ~/kalan/sw/ ]; then
    mkdir -p ~/kalan/sw/
fi
if [ ! -e ~/kalan-data/conf/kalan.conf ];then
kalan_hash=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16)
#####SCRIPT##### kalan.conf
cat << EOF > ~/kalan-data/conf/kalan.conf
VERSION_ORIGINAL=$KALAN_VERSION
VERSION_ACTUAL=$KALAN_VERSION
URL_ACTUALIZACION=https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh
DESTINO_PROXY_DEFAULT=http://localhost:8888
KALANPG_MD5=$kalan_hash
PACKAGE_MANAGER=$PACKAGE_MANAGER
EOF
#####ENDSCRIPT##### kalan.conf
fi
source ~/kalan/scripts/kalan-lib.sh
replaceLinesThanContain "VERSION_ACTUAL" "VERSION_ACTUAL=$KALAN_VERSION" ~/kalan-data/conf/kalan.conf

chmod -R 770 ~/kalan/scripts
chmod +x ~/kalan/scripts/kalan.sh
chmod +x ~/kalan/scripts/kalan-update.sh
chmod +x ~/kalan/scripts/kregisterscript.sh
chmod +x ~/kalan/scripts/kregisterscriptsfolder.sh
~/kalan/scripts/kregisterscriptsfolder.sh
}

f_create_scripts
cd $current_dir
fi
}

main "$@"
