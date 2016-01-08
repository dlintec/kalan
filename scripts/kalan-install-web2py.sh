#!/bin/bash
source ~/kalan/scripts/kalan-lib.sh
KALAN_IP=$(~/kalan/scripts/get-ip-address.sh)
KALAN_WEB2PY_PORT=8888
KALAN_HOSTNAME=$HOSTNAME


cat << 'EOFsystemctl' > ~/kalan/standard/web2pyd.systemctl.standard
[Unit]
Description=Servidor web2pyd
[Service]

User=kalan
ExecStart=/usr/local/bin/python2.7 /var/web-apps/web2py/web2py.py --nogui -a "<recycle>" -i 127.0.0.1 -p 8888
Restart=on-abort
[Install]
WantedBy=multi-user.target

EOFsystemctl

# Download
if [ ! -e ~/kalan/sw/web2py_src.zip ]; then
    cd ~/kalan/sw/
wget web2py.com/examples/static/2.12.1/web2py_src.zip
fi
yes | \cp -rf ~/kalan/sw/web2py_src.zip /var/web-apps/web2py_src.zip

cd /var/web-apps
unzip web2py_src.zip

chown -R kalan:kalan web2py
cd /opt


# Setup the proper context on the writable application directories
cd /var/web-apps/web2py/applications

yes | \cp -rf ~/kalan/standard/web2pyd.systemctl.standard /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_IP##" "$KALAN_IP" /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_WEB2PY_PORT##" "$KALAN_WEB2PY_PORT" /etc/systemd/system/web2pyd.service


#chmod +x /etc/systemd/system/web2pyd.service
#systemctl daemon-reload

systemctl enable  web2pyd.service
#systemctl daemon-reload
