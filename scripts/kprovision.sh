#!/bin/bash
#/opt/kalan/scripts/kbuild.sh
main() {
   imagetag="$1";shift;
   param2="$1";shift;
   if [[ -d /opt/kalan/dockerfiles/$imagetag ]];then
      cd /opt/kalan/dockerfiles/$imagetag
      docker build -t $imagetag .
   else
      echo "Must provide a valid folder name in /opt/kalan/dockerfiles with valid dockerfile"
      echo "folder:$imagetag"
      echo "$param2"
   fi
}

main "$@"
