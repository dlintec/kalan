#!/bin/bash
cd /opt/kalan/dockerfiles/kalan-docker
#docker rm -v $(docker ps -a -q)
#docker rmi $(docker images -q)
docker rmi kalan-docker
docker build -t kalan-docker .
#docker run --name kalan1 -it --rm=true --tty=true kalan-docker
