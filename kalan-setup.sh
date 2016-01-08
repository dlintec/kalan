main() {
# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i
# curl -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i
PARAMETRO="$1"

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_VERSION="2.0.0"
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
if [ ! -e ~/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git ~/kalan
fi
cd ~/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x ~/kalan/kalan-setup.sh
chmod -R 770 ~/kalan/scripts
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
source ~/kalan/src/kalan-lib.sh
replaceLinesThanContain "VERSION_ACTUAL" "VERSION_ACTUAL=$KALAN_VERSION" ~/kalan-data/conf/kalan.conf

chmod -R 770 ~/kalan/scripts
chmod +x ~/kalan/src/kalan.sh
chmod +x ~/kalan/src/kalan-update.sh
chmod +x ~/kalan/src/kregisterscript.sh
chmod +x ~/kalan/src/kregisterscriptsfolder.sh
cd ~/kalan/src/
./kregisterscriptsfolder.sh
echo "export PATH=$PATH:~/kalan/bin"  >> ~/.bash_profile
echo "export PATH=$PATH:~/kalan/bin"  >> ~/.bashrc

}

f_create_scripts
cd $current_dir

}

main "$@"
