#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "You must have root powers to install the container host (docker)" 2>&1
   exit 1
else
   if id -u "kalan" >/dev/null 2>&1; then
           echo "user kalan already created"
   else
           echo "Creating user kalan."
                   useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
                   echo "export PATH=$PATH:/HOME/$USER/kalan/scripts"  >> ~/.bash_profile
                   echo "export PATH=$PATH:/HOME/$USER/kalan/scripts"  >> ~/.bashrc
   fi
   ~/kalan/src/kalan-install-core.sh
   ~/kalan/src/kalan-install-docker.sh
   chown -R kalan:kalan ~/kalan
   chgrp -R kalan ~/kalan-data
   chmod -R 771 ~/kalan
   chmod -R 771 ~/kalan-data
if
