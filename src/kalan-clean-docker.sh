#!/bin/bash
docker rm -v $(docker ps -a -q)
docker rmi $(docker images -q)
