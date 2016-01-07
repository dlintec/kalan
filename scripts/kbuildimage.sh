#!/bin/bash
#/var/kalan/scripts/kbuild.sh
main() {
   dockerfile="$1";shift;
   param2="$1";shift;
   if [[ -d /var/kalan/dockerfiles/$dockerfile ]];then
      cd /var/kalan/dockerfiles/$dockerfile
      docker build -t $dockerfile .
   else
      echo "Must provide a valid folder name in /var/kalan/dockerfiles with valid dockerfile"
      echo "folder:$dockerfile"
      echo "$param2"
   fi
}

main "$@"
