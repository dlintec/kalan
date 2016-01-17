#!/bin/bash
sudo docker rm -v $(docker ps -a -q)
sudo docker rmi $(docker images -q)
