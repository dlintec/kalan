#!/bin/bash
#Agregado kalan
ip add | grep "inet " | grep -v "127.0.0.1" | awk '{ print $2 }' | awk -F'/' '{print $1}'
#FIN Agregado kalan
