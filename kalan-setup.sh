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
$PACKAGE_MANAGER -y install git curl wget
export PACKAGE_MANAGER
if [ ! -e /opt/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
fi
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /opt/kalan/kalan-setup.sh
chmod -R 770 /opt/kalan/scripts
chmod +x /opt/kalan/scripts/kalan.sh
chmod +x /opt/kalan/scripts/kalan-update.sh
chmod +x /opt/kalan/scripts/kregisterscript.sh
chmod +x /opt/kalan/scripts/kregisterscriptsfolder.sh
source /opt/kalan/scripts/kalan-lib.sh

function f_create_scripts {

echo "Creando scripts"
if [ ! -d /opt/kalan/scripts/ ]; then
    mkdir -p /opt/kalan/scripts/
fi
if [ ! -d /opt/kalan/sw/ ]; then
    mkdir -p /opt/kalan/sw/
fi
if [ ! -d /opt/kalan/standard/ ]; then
    mkdir -p /opt/kalan/standard/
fi
if [ ! -d /opt/kalan-data/conf/ ]; then
    mkdir -p /opt/kalan-data/conf/
fi
if [ ! -d "/opt/web-apps" ]; then
    mkdir -p /opt/web-apps
    chmod -R 775 /opt/web-apps
fi
if [ ! -d /opt/kalan/sw/ ]; then
    mkdir -p /opt/kalan/sw/
fi
if [ ! -e /opt/kalan-data/conf/kalan.conf ];then
kalan_hash=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16)
#####SCRIPT##### kalan.conf
cat << EOF > /opt/kalan-data/conf/kalan.conf
VERSION_ORIGINAL=$KALAN_VERSION
VERSION_ACTUAL=$KALAN_VERSION
URL_ACTUALIZACION=https://dlintec-inteligencia.com:8888/SG/static/act/kalan-actualizacion-web
DESTINO_PROXY_DEFAULT=http://localhost:8888
KALANPG_MD5=$kalan_hash
PACKAGE_MANAGER=$PACKAGE_MANAGER
EOF
#####ENDSCRIPT##### kalan.conf
fi
source /opt/kalan/scripts/kalan-lib.sh
replaceLinesThanContain "VERSION_ACTUAL" "VERSION_ACTUAL=$KALAN_VERSION" /opt/kalan-data/conf/kalan.conf

chmod -R 770 /opt/kalan/scripts
chmod +x /opt/kalan/scripts/kalan.sh
chmod +x /opt/kalan/scripts/kalan-update.sh
chmod +x /opt/kalan/scripts/kregisterscript.sh
chmod +x /opt/kalan/scripts/kregisterscriptsfolder.sh
/opt/kalan/scripts/kregisterscriptsfolder.sh
}

f_create_scripts

}

main "$@"
