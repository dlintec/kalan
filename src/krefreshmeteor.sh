#!/bin/bash
KALAN_DIR="$HOME/kalan"

sudo docker run -it -v $KALAN_DIR-data/provisions/kalan/met:/opt/application kalan_meteor meteor-kitchen start.json start

