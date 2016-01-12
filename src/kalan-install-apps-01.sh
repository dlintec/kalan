#!/bin/bash 
param1="$1";shift 
KALAN_USER="$(who am i | awk '{print $1}')" 
KALAN_DIR="$HOME/kalan" 
current_dir=`pwd` 

sudo apt-get -y install blender mypaint gimp scribus openshot avidemux  darktable inkscape virtualbox vlc browser-plugin-vlc

#sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
#wget https://github.com/aptana/studio3/releases/download/v3.6.1/Aptana_Studio_3_Setup_Linux_x86_64_3.6.1.zip
