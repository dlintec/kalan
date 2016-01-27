#!/bin/bash
KALAN_DIR="$HOME/kalan"
exec kprovision kalan --remove
clear
exec kprovision kalan --admin admin
