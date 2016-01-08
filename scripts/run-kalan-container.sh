#!/bin/bash
#~/kalan/scripts/run-kalan-container.sh
mkdir -p ~/kalan-data/w2p/errors
mkdir -p ~/kalan-data/w2p/sessions
mkdir -p ~/kalan-data/w2p/databases
mkdir -p ~/kalan-data/w2p/uploads

docker create \
   -v ~/kalan/start:/home/www-data/web2py/applications/start \
   -v ~/kalan-data/w2p/errors:/home/www-data/web2py/applications/start/errors \
   -v ~/kalan-data/w2p/sessions:/home/www-data/web2py/applications/start/sessions \
   -v ~/kalan-data/w2p/databases:/home/www-data/web2py/applications/start/databases \
   -v ~/kalan-data/w2p/uploads:/home/www-data/web2py/applications/start/uploads \
   --name kdc-start-app ubuntu

docker stop kalan-1
docker rm -v kalan-1
docker run -p 80:80 -p 443:443 -p 8888:8888 \
   --volumes-from kdc-start-app -d \
   --name kalan-1 k-w2p
#docker rm -v $(docker ps -a -q)
#docker rmi $(docker images -q)
#docker run --name kalan1 -it --rm=true --tty=true kalan-docker
