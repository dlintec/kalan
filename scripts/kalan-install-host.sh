#!/bin/bash
if id -u "kalan" >/dev/null 2>&1; then
        echo "user kalan already created"
else
        echo "Creating user kalan."
                useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
fi

/opt/kalan/scripts/kalan-install-core.sh
/opt/kalan/scripts/kalan-install-docker.sh
chown -R kalan:kalan /opt/kalan
chgrp -R kalan /opt/kalan-data
chmod -R 771 /opt/kalan
chmod -R 771 /opt/kalan-data
