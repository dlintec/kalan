#!/bin/bash
#~/kalan/src/kbuild.sh
main() {
   dockerfile="$1";shift;
   param2="$1";shift;
   KALAN_DIR="$HOME/kalan"
   if sudo docker history -q $dockerfile 2>&1 >/dev/null; then
    echo "image $dockerfile exists"
   else
    echo "image $dockerfile does not exist"
   fi
   if [[ -e $KALAN_DIR/dockerfiles/$dockerfile ]];then
      cd $KALAN_DIR/dockerfiles/$dockerfile
      sudo docker build -t $dockerfile .
      RESULT=$?
      if [ $RESULT -eq 0 ]; then
        img_dir="$KALAN_DIR-data/docker-images"
        if [[ ! -d $img_dir ]];then
           mkdir -p $img_dir
        fi
        if [[ ! -e $img_dir/kalan-base.tar ]];then
            echo "Saving kalan-base image en $img_dir "
            sudo docker save -o $img_dir/$kalan-base.tar ubuntu
        fi
        echo "please wait...saving image to $img_dir/$dockerfile.tar "
        sudo docker save -o $img_dir/$dockerfile.tar $dockerfile
        echo success
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
