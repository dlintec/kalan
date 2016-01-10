main() {
# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i
# curl -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i

PARAMETRO="$1"

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
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
if ! [ -x "$(command -v git)" ]; then
  echo "-------------------------------------------------------------------------"
  echo "   Git is not installed"
  echo "   We will use: sudo $PACKAGE_MANAGER install git"
  echo "-------------------------------------------------------------------------"
 
  sudo apt-get -y install git
  echo "   Gin installed, try again: "
  echo "   url -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i"
  echo
else

    export PACKAGE_MANAGER="$PACKAGE_MANAGER"
    if [ ! -e $KALAN_DIR/README.md ];then
       git clone --recursive https://github.com/dlintec/kalan.git $KALAN_DIR
    else
      cd $KALAN_DIR
      git fetch origin
      git reset --hard origin/master
      git pull

    fi

    chmod -R 770 $KALAN_DIR/src

    source $KALAN_DIR/src/kalan-lib.sh

    echo "Creando scripts"
    echo "-------------------------------------------------------------------------"
    cd $KALAN_DIR/src/
    ./kregisterscriptsfolder.sh
    echo "export PATH=$PATH:$KALAN_DIR/bin"  >> ~/.bash_profile
    echo "export PATH=$PATH:$KALAN_DIR/bin"  >> ~/.bashrc
    export PATH=$PATH:$KALAN_DIR/bin
    cd $current_dir
fi

}

main "$@"
