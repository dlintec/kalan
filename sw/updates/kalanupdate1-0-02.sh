#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
curl -L https://github.com/docker/compose/releases/download/1.6.0-rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
