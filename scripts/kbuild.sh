#!/bin/bash
#/opt/kalan/scripts/kbuild.sh
main() {
   dockerfile="$1";shift;
   param2="$1";shift;
   if [[ -d /opt/kalan/dockerfiles/$dockerfile ]];then
      cd /opt/kalan/dockerfiles/$dockerfile
      docker build -t $dockerfile .
   else
      echo "Must provide a valid folder name in /opt/kalan/dockerfiles with valid dockerfile"
      echo "folder:$dockerfile"
      echo "$param2"
   fi
}

main "$@"
