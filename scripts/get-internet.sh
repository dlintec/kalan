#!/bin/bash
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
    echo "1"
else
    echo "0"
fi
