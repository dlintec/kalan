#!/bin/bash
mkdir -p /opt/kalan-data/w2p/errors
mkdir -p /opt/kalan-data/w2p/sessions
mkdir -p /opt/kalan-data/w2p/databases
mkdir -p /opt/kalan-data/w2p/uploads

docker create \
   -v /opt/kalan/start:/home/www-data/web2py/applications/start \
   -v /opt/kalan-data/w2p/errors:/home/www-data/web2py/applications/start/errors \
   -v /opt/kalan-data/w2p/sessions:/home/www-data/web2py/applications/start/sessions \
   -v /opt/kalan-data/w2p/databases:/home/www-data/web2py/applications/start/databases \
   -v /opt/kalan-data/w2p/uploads:/home/www-data/web2py/applications/start/uploads \
   --name kdc-start-app ubuntu
docker run -p 80:8888 -p 443:443 -p \
   --volumes-from kdc-start-app -d \
   --name kalan-1 kalan-web2py
#docker rm -v $(docker ps -a -q)
#docker rmi $(docker images -q)
#docker run --name kalan1 -it --rm=true --tty=true kalan-docker
