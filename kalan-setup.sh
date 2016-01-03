main() {
# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i
PARAMETRO="$1"
KALAN_VERSION="2.0.0"
current_dir=`pwd`
yum -y update
yum -y install git curl wget
git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
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

if [ ! -e /opt/kalan-data/conf/kalan.conf ];then
kalan_hash=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16)
#####SCRIPT##### kalan.conf
cat << EOF > /opt/kalan-data/conf/kalan.conf
VERSION_ORIGINAL=$KALAN_VERSION
VERSION_ACTUAL=$KALAN_VERSION
URL_ACTUALIZACION=https://dlintec-inteligencia.com:8888/SG/static/act/kalan-actualizacion-web
DESTINO_PROXY_DEFAULT=http://localhost:8888
KALANPG_MD5=$kalan_hash
EOF
#####ENDSCRIPT##### kalan.conf
fi

#####SCRIPT##### kalan-install-docker.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-install-docker.sh
#!/bin/bash
curl -sSL https://get.docker.com/ | sh
sudo service docker start
sudo systemctl enable docker
curl -L https://github.com/docker/machine/releases/download/v0.5.3/docker-machine_linux-amd64 >/usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine
curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
EOF
chmod 770 /opt/kalan/scripts/kalan-install-docker.sh
ln -sf /opt/kalan/scripts/kalan-install-docker.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-install-docker

#####SCRIPT##### create-kalan-container.sh
cat << 'EOF' > /opt/kalan/scripts/create-kalan-container.sh
#!/bin/bash
cd /opt/kalan/dockerfiles/kalan-docker
docker build -t kalan-docker .
EOF
chmod 770 /opt/kalan/scripts/create-kalan-container.sh
ln -sf /opt/kalan/scripts/create-kalan-container.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-install-docker
#####SCRIPT##### kalan-install-python.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-install-python.sh
#!/bin/bash
echo "Siguente: Instalar Python"
#read CONFIRM
parametro=$1
cd /opt/kalan/sw
yum -y install python-2.7*
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

if [ ! -e /opt/kalan/sw/kalan-py-req.txt ];then
cat << ARCHREQ > /opt/kalan/sw/kalan-py-req.txt
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
psycopg2==2.6.1
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

ARCHREQ
fi

ls /opt/kalan/sw/pip > /opt/kalan/sw/pips
cd /opt/kalan/sw/pip

if [ "$parametro" != "postinstall" ];then
	echo " "
	echo "Descargando paquetes si no estan localmente"
	echo "------------------------------------------------------------------------------"
	/usr/local/bin/pip2.7 install --download /opt/kalan/sw/pip -r /opt/kalan/sw/kalan-py-req.txt
fi

echo "Instalando paquetes locales"
echo "------------------------------------------------------------------------------"
/usr/local/bin/pip2.7 install -r /opt/kalan/sw/kalan-py-req.txt --no-index --find-links file:///opt/kalan/sw/pip

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

#####SCRIPT##### kalan-update.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-update.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
#(
cd /opt/
git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /opt/kalan/kalan-setup.sh

#) 2>&1 | tee /var/log/kalan/instalar-meanstack.sh.log
EOF
chmod +x /opt/kalan/scripts/kalan-update.sh
ln -sf /opt/kalan/scripts/kalan-update.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-update.sh
}

f_create_scripts
}

main "$@"
