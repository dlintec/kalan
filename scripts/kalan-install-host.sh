#!/bin/bash
if id -u "kalan" >/dev/null 2>&1; then
        echo "user kalan already created"
else
        echo "Creating user kalan."
                useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
fi

/var/kalan/scripts/kalan-install-core.sh
/var/kalan/scripts/kalan-install-docker.sh
chown -R kalan:kalan /var/kalan
chgrp -R kalan /var/kalan-data
chmod -R 771 /var/kalan
chmod -R 771 /var/kalan-data
