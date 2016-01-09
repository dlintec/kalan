#!/bin/bash
#~/kalan/src/kbuild.sh
main() {
   dockerfile="$1";shift;
   param2="$1";shift;
   if [[ -d ~/kalan/dockerfiles/$dockerfile ]];then
      cd ~/kalan/dockerfiles/$dockerfile
      sudo docker build -t $dockerfile .
   else
      echo "Must provide a valid folder name in ~/kalan/dockerfiles with valid dockerfile"
      echo "folder:$dockerfile"
      echo "$param2"
   fi
}

main "$@"
