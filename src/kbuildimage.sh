#!/bin/bash
#~/kalan/src/kbuild.sh
main() {
   dockerfile="$1";shift;
   param2="$1";shift;
   KALAN_DIR="$HOME/kalan"
   if [[ $KALAN_DIR/dockerfiles/$dockerfile ]];then
      cd $KALAN_DIR/dockerfiles/$dockerfile
      sudo docker build -t $dockerfile .
      RESULT=$?
      if [ $RESULT -eq 0 ]; then
        echo success
        img_dir="$KALAN_DIR-data/docker-images"
        if [[ ! -d $img_dir ]];then
           mkdir -p $img_dir
        fi
        docker save -o $img_dir/$dockerfile.tar $dockerfile
      else
        echo failed
      fi
   else
      echo "Must provide a valid folder name in $KALAN_DIR/dockerfiles with valid dockerfile"
      echo "folder:$dockerfile"
      echo "$param2"
   fi
}

main "$@"
