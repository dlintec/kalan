main() {
# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i
PARAMETRO="$1"
KALAN_VERSION="2.0.0"
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
if [ ! -e /var/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git /var/kalan
fi
cd /var/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /var/kalan/kalan-setup.sh
chmod -R 770 /var/kalan/scripts
chmod +x /var/kalan/scripts/kalan.sh
chmod +x /var/kalan/scripts/kalan-update.sh
chmod +x /var/kalan/scripts/kregisterscript.sh
chmod +x /var/kalan/scripts/kregisterscriptsfolder.sh
source /var/kalan/scripts/kalan-lib.sh

function f_create_scripts {

echo "Creando scripts"
echo "-------------------------------------------------------------------------"
if [ ! -d /var/kalan/scripts/ ]; then
    mkdir -p /var/kalan/scripts/
fi
if [ ! -d /var/kalan/sw/ ]; then
    mkdir -p /var/kalan/sw/
fi
if [ ! -d /var/kalan/standard/ ]; then
    mkdir -p /var/kalan/standard/
fi
if [ ! -d /var/kalan-data/conf/ ]; then
    mkdir -p /var/kalan-data/conf/
fi
if [ ! -d "/var/web-apps" ]; then
    mkdir -p /var/web-apps
    chmod -R 775 /var/web-apps
fi
if [ ! -d /var/kalan/sw/ ]; then
    mkdir -p /var/kalan/sw/
fi
if [ ! -e /var/kalan-data/conf/kalan.conf ];then
kalan_hash=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16)
#####SCRIPT##### kalan.conf
cat << EOF > /var/kalan-data/conf/kalan.conf
VERSION_ORIGINAL=$KALAN_VERSION
VERSION_ACTUAL=$KALAN_VERSION
URL_ACTUALIZACION=https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh
DESTINO_PROXY_DEFAULT=http://localhost:8888
KALANPG_MD5=$kalan_hash
PACKAGE_MANAGER=$PACKAGE_MANAGER
EOF
#####ENDSCRIPT##### kalan.conf
fi
source /var/kalan/scripts/kalan-lib.sh
replaceLinesThanContain "VERSION_ACTUAL" "VERSION_ACTUAL=$KALAN_VERSION" /var/kalan-data/conf/kalan.conf

chmod -R 770 /var/kalan/scripts
chmod +x /var/kalan/scripts/kalan.sh
chmod +x /var/kalan/scripts/kalan-update.sh
chmod +x /var/kalan/scripts/kregisterscript.sh
chmod +x /var/kalan/scripts/kregisterscriptsfolder.sh
/var/kalan/scripts/kregisterscriptsfolder.sh
}

f_create_scripts

}

main "$@"
