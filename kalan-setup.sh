main() {
# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | sh -i
PARAMETRO="$1"
KALAN_VERSION="2.0.0"
current_dir=`pwd`
yum -y install git
git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /opt/kalan/kalan-setup.sh


}

main "$@"
