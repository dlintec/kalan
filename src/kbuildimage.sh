#!/bin/bash
#~/kalan/src/kbuildimage.sh
main() {
   pdockerfile="$1";shift;
   pimagename="$1";shift;
   KALAN_DIR="$HOME/kalan"
   
   if [[ -z "$pdockerfile" ]];then
      pdockerfile="$(pwd)/dockerfile"
   fi
   if [[ -e $pdockerfile ]];then
      sudo docker build -t $pimagename $pdockerfile
      RESULT=$?
      if [ $RESULT -eq 0 ]; then
        echo success
      else
        echo failed
      fi
   else
      echo "Must provide a valid folder name with valid dockerfile"
      echo "folder:$pdockerfile"
      echo "$pimagename"
   fi
}

main "$@"
