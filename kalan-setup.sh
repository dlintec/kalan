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

if [ ! -e /opt/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
fi
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /opt/kalan/kalan-setup.sh

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

#####SCRIPT##### kalan-lib.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-lib.sh
NORMAL=`echo "\033[m"`
MENU=`echo "\033[36m"` #Blue
NUMBER=`echo "\033[33m"` #yellow
FGRED=`echo "\033[41m"`
RED_TEXT=`echo "\033[31m"`
ENTER_LINE=`echo "\033[33m"`
function reemplazarEnArch {
  sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}
function replaceLinesThanContain {
	archivo="$3"
	nuevacad="$2"
	buscar="$1"
	temporal="$archivo.tmp.kalan"
	listalineas=$(cat $archivo)
	if [[ !  -z  $listalineas  ]];then
		#echo "reemplazando lineas existentes con:"
		#echo "$nuevacad"
		>$temporal
		while read -r linea; do
			if [[ $linea == *"$buscar"* ]];then
			  #echo "... $linea ..."
			  echo "$nuevacad" >> $temporal;
			else
			  echo "$linea" >> $temporal;

			fi
		done <<< "$listalineas"
	    cat $temporal > $archivo
		rm -rf $temporal
	else
		echo "agregando nueva linea $nuevacad"
		echo $nuevacad>>$archivo
	fi
}
function versionOS {
 rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)
}
function kalan-var {
   if [[ -z $2 ]];then
      sed "y/ ,/\n\n/;/^$1/P;D" </opt/kalan-data/conf/kalan.conf | awk -F= '{print $NF}'
   else
      replaceLinesThanContain "$1" "$1=$2" /opt/kalan-data/conf/kalan.conf
   fi

}

function pruebaLib {
   echo "Libreria Importada OK"
   echo $(versionOS)
}
function doublePassword {
pwOk=No
mensaje=""
while true
do
   PW=$(whiptail --nocancel --title "$1" --passwordbox "$mensaje
Teclee una clave y ENTER para continuar" 10 50 3>&1 1>&2 2>&3)

   PW2=$(whiptail --nocancel --title "$1" --passwordbox "Teclee nuevamente la clave y ENTER para continuar." 10 40 3>&1 1>&2 2>&3)
   exitstatus=$?
	if [ $exitstatus = 0 ]; then
		if [ "$PW" == "$PW2" ];then
			pwOk="ok"
			echo "$PW"
			return
	    else
			mensaje="ERROR: Las claves no coinciden. "
		fi
	else
		echo "error"
		return
	fi
done
}
EOF
#####ENDSCRIPT##### kalan-lib.sh

#####SCRIPT##### get-ip-address.sh
cat << 'EOF' > /opt/kalan/scripts/get-ip-address.sh
#!/bin/bash
#Agregado kalan
ip add | grep "inet " | grep -v "127.0.0.1" | awk '{ print $2 }' | awk -F'/' '{print $1}'
#FIN Agregado kalan
EOF
chmod +x /opt/kalan/scripts/get-ip-address.sh
ln -sf /opt/kalan/scripts/get-ip-address.sh /usr/local/bin/
#####ENDSCRIPT##### get-ip-address.sh

#####SCRIPT##### get-internet.sh
cat << 'EOF' > /opt/kalan/scripts/get-internet.sh
#!/bin/bash
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
    echo "1"
else
    echo "0"
fi
EOF
chmod +x /opt/kalan/scripts/get-internet.sh
ln -sf /opt/kalan/scripts/get-internet.sh /usr/local/bin/
ln -sf /opt/kalan/scripts/get-internet.sh /usr/local/bin/get-internet
#####ENDSCRIPT##### get-internet.sh


cat << 'EOF' >/opt/kalan/sw/kalan-core-yum.fil
deltarpm python-deltarpm yum-utils unzip nano net-tools wget git ntp dialog dvd+rw-tools createrepo sudo
gcc make zlib-devel bzip2-devel  ncurses-devel libxml2-devel libxml2 libxml2-python libxslt-devel  pcre-devel curl-devel python-devel
policycoreutils-python nmap openscap openscap-scanner scap-security-guide openssl openssl-devel
sqlite sqlite-devel mysql-devel unixODBC-devel postgresql-devel
postgresql postgresql-server postgresql-contrib postgresql-libs postgresql-plperl postgresql-plpython python-psycopg2
graphviz graphviz-devel ImageMagick supervisor openssh-server
xz-libs
vim-enhanced*
genisoimage  libusal pykickstart
chrony
EOF

cat << 'EOF' >/opt/kalan/sw/kalan-core-apt-get.fil
nginx-full
build-essential python-dev libxml2-dev python-pip supervisor
unzip nano net-tools wget git ntp dialog sudo openssh-server
gcc make zlib1g-dev libbz2-dev libncurses-dev libxml2-dev libxml2 libxml2-dev libxslt1-dev libxslt-dev  libpcre3-dev  libcurl3-dev python-dev
nmap openssl libssl-dev
sqlite libsqlite-dev libmysqld-dev unixodbc-dev libpq-dev
postgresql postgresql-contrib postgresql-plperl postgresql-plpython python-psycopg2
graphviz libgraphviz-dev ImageMagick supervisor python-pygraphviz
xz-utils
EOF


#####SCRIPT##### /opt/kalan/sw/kalan-py-req-yum.txt

cat << EOF > /opt/kalan/sw/kalan-py-req-yum.txt
pyasn1==0.1.7
argparse==1.4.0
beautifulsoup4==4.4.1
google-api-python-client==1.4.2
graphviz==0.4.8
lxml==3.5.0
mechanize==0.2.5
meld3==1.0.2
oauth2client==1.5.2
oauthlib==1.0.3
pbr==1.8.1
psycopg2
pygraphviz==1.3.1
pymongo==3.2
requests==2.9.1
requests_oauthlib==0.6.0
simplejson==3.8.1
six==1.10.0
stevedore==1.10.0
supervisor==3.2.0
tweepy==3.5.0
virtualenv==13.1.2
virtualenv-clone==0.2.6
virtualenvwrapper==4.7.1
web2py_utils
httplib2
docker-py

EOF
#####SCRIPT##### /opt/kalan/sw/kalan-py-req-yum.txt


#####SCRIPT##### /opt/kalan/sw/kalan-py-req-apt-get.txt

cat << EOF > /opt/kalan/sw/kalan-py-req-apt-get.txt
pyasn1
argparse
beautifulsoup4
google-api-python-client
graphviz
lxml
mechanize
meld3
oauth2client
oauthlib
pbr
psycopg2
pygraphviz
pymongo
requests
requests_oauthlib
simplejson
six
stevedore
supervisor
tweepy
virtualenv
virtualenv-clone
virtualenvwrapper
httplib2
docker-py

EOF
#####FINSCRIPT##### /opt/kalan/sw/kalan-py-req-apt-get.txt

#####SCRIPT##### kalan-core-yum.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-core-yum.sh
#!/bin/bash
# Verify packages are up to date
parametro="$1"
# Install required packages

#httpd httpd-devel mod_ssl
#kernel-devel
#firewalld
echo "------------------------- kalan-core-yum----------------------------"
echo "parametro: $parametro"
if [ "$parametro" != "postinstall" ]; then
   yum -y update
   yum install -y epel-release
   yum -y upgrade
   yum -y install $(cat /opt/kalan/sw/kalan-core-yum.fil)
fi
EOF
chmod 770 /opt/kalan/scripts/kalan-core-yum.sh
ln -sf /opt/kalan/scripts/kalan-core-yum.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-core-yum.sh

#####SCRIPT##### kalan-core-apt-get.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-core-apt-get.sh
#!/bin/bash
# Verify packages are up to date
parametro="$1"
# Install required packages

#httpd httpd-devel mod_ssl
#kernel-devel
#firewalld
echo "------------------------- kalan-core-apt-get----------------------------"
echo "parametro: $parametro"
if [ "$parametro" != "postinstall" ]; then
   apt-get -y update
   apt-get -y install $(cat /opt/kalan/sw/kalan-core-apt-get.fil)
fi
EOF
chmod 770 /opt/kalan/scripts/kalan-core-apt-get.sh
ln -sf /opt/kalan/scripts/kalan-core-apt-get.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-core-yum.sh

#####SCRIPT##### kalan-install-core.sh
cat << EOF > /opt/kalan/scripts/kalan-install-core.sh
#!/bin/bash
/opt/kalan/scripts/kalan-core-$PACKAGE_MANAGER.sh
EOF
chmod 770 /opt/kalan/scripts/kalan-install-core.sh
ln -sf /opt/kalan/scripts/kalan-install-core.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-install-core

#####SCRIPT##### kalan-install-python.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-install-python.sh
#!/bin/bash
echo "Siguente: Instalar Python"
#read CONFIRM
parametro=$1
cd /opt/kalan/sw

if [ ! -e /opt/kalan/sw/Python-2.7.11.tar.xz ];then
    wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
fi
tar xf Python-2.7.11.tar.xz
cd Python-2.7.11
./configure --prefix=/usr/local
make && make altinstall

cd /opt/kalan/sw
if [ ! -e /opt/kalan/sw/setuptools-19.1.1.tar.gz ];then
   wget https://pypi.python.org/packages/source/s/setuptools/setuptools-19.1.1.tar.gz#md5=792297b8918afa9faf826cb5ec4a447a
fi

tar xzf setuptools-19.1.1.tar.gz
cd /opt/kalan/sw/setuptools-19.1.1
python2.7 setup.py install


cd /opt/kalan/sw

if [ ! -e /opt/kalan/sw/pip-7.1.2.tar.gz ];then
	wget https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz#md5=3823d2343d9f3aaab21cf9c917710196
fi

tar xzf pip-7.1.2.tar.gz
cd /opt/kalan/sw/pip-7.1.2
python2.7 setup.py install

if [ ! -e /opt/kalan/sw/google-api-python-client-1.4.2.tar.gz ];then
	wget https://pypi.python.org/packages/source/g/google-api-python-client/google-api-python-client-1.4.2.tar.gz#md5=7033985a645e39d3ccf1b2971ab7b6b8
fi

tar xzf google-api-python-client-1.4.2.tar.gz
cd /opt/kalan/sw/google-api-python-client-1.4.2
python2.7 setup.py install

if [ ! -d /opt/kalan/sw/pip ];then
	mkdir -p /opt/kalan/sw/pip
fi

#if [ ! -e /opt/kalan/sw/kalan-py-req.txt ];then

#fi

ls /opt/kalan/sw/pip > /opt/kalan/sw/pips
cd /opt/kalan/sw/pip

if [ "$parametro" != "postinstall" ];then
	echo " "
	echo "Descargando paquetes si no estan localmente"
	echo "------------------------------------------------------------------------------"
	pip2.7 install --download /opt/kalan/sw/pip -r /opt/kalan/sw/kalan-py-req.txt
fi

echo "Instalando paquetes locales"
echo "------------------------------------------------------------------------------"
pip2.7 install -r /opt/kalan/sw/kalan-py-req.txt --no-index --find-links file:///opt/kalan/sw/pip

echo " "
echo "______________________________________________________________________________"
echo "FIN Instalacion Python. Verifique si no hay Errores:"
echo "presione ENTER para continuar...[ctrl+C para abortar]"
echo "Siguiente: Instalar "
#read CONFIRM
EOF
chmod 770 /opt/kalan/scripts/kalan-install-python.sh
ln -sf /opt/kalan/scripts/kalan-install-python.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-install-python.sh

#####SCRIPT##### kalan-install-web2py.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-install-web2py.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
KALAN_IP=$(/opt/kalan/scripts/get-ip-address.sh)
KALAN_WEB2PY_PORT=8888
KALAN_HOSTNAME=$HOSTNAME


cat << 'EOFsystemctl' > /opt/kalan/standard/web2pyd.systemctl.standard
[Unit]
Description=Servidor web2pyd
[Service]

User=kalan
ExecStart=/usr/local/bin/python2.7 /opt/web-apps/web2py/web2py.py --nogui -a "<recycle>" -i 127.0.0.1 -p 8888
Restart=on-abort
[Install]
WantedBy=multi-user.target

EOFsystemctl

# Download
if [ ! -e /opt/kalan/sw/web2py_src.zip ]; then
    cd /opt/kalan/sw/
	wget web2py.com/examples/static/2.12.1/web2py_src.zip
fi
yes | \cp -rf /opt/kalan/sw/web2py_src.zip /opt/web-apps/web2py_src.zip

cd /opt/web-apps
unzip web2py_src.zip

chown -R kalan:kalan web2py
cd /opt


# Setup the proper context on the writable application directories
cd /opt/web-apps/web2py/applications

yes | \cp -rf /opt/kalan/standard/web2pyd.systemctl.standard /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_IP##" "$KALAN_IP" /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_WEB2PY_PORT##" "$KALAN_WEB2PY_PORT" /etc/systemd/system/web2pyd.service


#chmod +x /etc/systemd/system/web2pyd.service
#systemctl daemon-reload

systemctl enable  web2pyd.service
#systemctl daemon-reload
EOF
chmod 770 /opt/kalan/scripts/kalan-install-web2py.sh
ln -sf /opt/kalan/scripts/kalan-install-web2py.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-install-web2py.sh

#####SCRIPT##### kalan-update.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-update.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh

cd /opt/
if [ ! -e /opt/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
fi
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /opt/kalan/kalan-setup.sh
#chown -R kalan:kalan /opt/kalan
#chown -R kalan:kalan /opt/kalan-data
#chmod -R 771 /opt/kalan
#chmod -R 771 /opt/kalan-data
EOF
chmod +x /opt/kalan/scripts/kalan-update.sh
ln -sf /opt/kalan/scripts/kalan-update.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-update.sh

#####SCRIPT##### kalan-install-docker.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-install-docker.sh
#!/bin/bash
curl -sSL https://get.docker.com/ | sh
service docker start
systemctl enable docker
curl -L https://github.com/docker/machine/releases/download/v0.5.3/docker-machine_linux-amd64 >/usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine
curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
EOF
chmod 770 /opt/kalan/scripts/kalan-install-docker.sh
ln -sf /opt/kalan/scripts/kalan-install-docker.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-install-docker


#####SCRIPT##### kalan-install-host.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-install-docker-host.sh
#!/bin/bash
if id -u "kalan" >/dev/null 2>&1; then
        echo "user kalan already created"
else
        echo "Creating user kalan."
                useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
fi

/opt/kalan/scripts/kalan-install-core.sh
/opt/kalan/scripts/kalan-install-docker.sh
chown -R kalan:kalan /opt/kalan
chown -R kalan:kalan /opt/kalan-data
chmod -R 771 /opt/kalan
chmod -R 771 /opt/kalan-data
EOF
chmod 770 /opt/kalan/scripts/kalan-install-docker-host.sh
ln -sf /opt/kalan/scripts/kalan-install-docker-host.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-install-host

#####SCRIPT##### create-kalan-container.sh
cat << 'EOF' > /opt/kalan/scripts/create-kalan-container.sh
#!/bin/bash
cd /opt/kalan/dockerfiles/kalan-docker
#docker rm -v $(docker ps -a -q)
#docker rmi $(docker images -q)
docker rmi kalan-docker
docker build -t kalan-docker .
#docker run --name kalan1 -it --rm=true --tty=true kalan-docker
EOF
chmod 770 /opt/kalan/scripts/create-kalan-container.sh
ln -sf /opt/kalan/scripts/create-kalan-container.sh /usr/local/bin/

#####ENDSCRIPT##### create-kalan-container

#####SCRIPT##### create-kalan-web2py.sh
cat << 'EOF' > /opt/kalan/scripts/create-kalan-web2py.sh
#!/bin/bash
cd /opt/kalan/dockerfiles/kalan-web2py
#docker rm -v $(docker ps -a -q)
#docker rmi $(docker images -q)
docker rmi kalan-web2py
docker build -t kalan-web2py .
#docker run --name kalan1 -it --rm=true --tty=true kalan-docker
EOF
chmod 770 /opt/kalan/scripts/create-kalan-web2py.sh
ln -sf /opt/kalan/scripts/create-kalan-web2py.sh /usr/local/bin/

#####ENDSCRIPT##### create-kalan-container

#####SCRIPT##### run-kalan-container.sh
cat << 'EOF' > /opt/kalan/scripts/run-kalan-container.sh
#!/bin/bash
docker create -v /opt/kalan/start --name kdc-start-app ubuntu
docker run -p 80:80 -p 443:443 --volumes-from kdc-start-app -d --name kalan-1 kalan-web2py
#docker rm -v $(docker ps -a -q)
#docker rmi $(docker images -q)
#docker run --name kalan1 -it --rm=true --tty=true kalan-docker
EOF
chmod 770 /opt/kalan/scripts/run-kalan-container.sh
ln -sf /opt/kalan/scripts/run-kalan-container.sh /usr/local/bin/

#####ENDSCRIPT##### create-kalan-container

#####SCRIPT##### kalan-clean-docker.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-clean-docker.sh
#!/bin/bash
docker rm -v $(docker ps -a -q)
docker rmi $(docker images -q)
EOF
chmod 770 /opt/kalan/scripts/kalan-clean-docker.sh
ln -sf /opt/kalan/scripts/kalan-clean-docker.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-clean-docker.sh

}

f_create_scripts
/opt/kalan/scripts/kalan-update.sh

}

main "$@"
