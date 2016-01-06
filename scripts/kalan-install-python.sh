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