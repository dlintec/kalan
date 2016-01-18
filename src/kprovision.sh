#!/bin/bash
#~/kalan/src/kprovision.sh
main() {
provisionname="$1";shift
rebuild=false
for arg in "$@" ; do
       case "$arg" in
         -n)
           provisionname=$2
           shift
           ;;
         -i)
           image_name=$2
           shift
           ;;
         -a)
           src_w2papps=$2
           shift
           ;;
         --remove)
           src_w2papps="--remove"
           ;;
         --rebuild)
           rebuild=true
           ;;
        esac
   done
  echo "name  = $provisionname"
  echo "image = $image_name"
  echo "apps  = $src_w2papps"
  KALAN_USER="$(who am i | awk '{print $1}')"
  KALAN_DIR="$HOME/kalan"

   KALAN_PROVISIONS_DIR="$KALAN_DIR-data/provisions"
   provisioncreated=false;
   container_appfolder="/var/kalan-container/web2py/applications"
   if [[ -z "$image_name" ]];then
	 image_name="k-w2p"
   fi
   
   if rebuild==true;then
   	echo "rebuilding..."
           $KALAN_DIR/src/kprovision.sh $provisionname --remove
           if sudo docker history -q $image_name 2>&1 >/dev/null; then
	    	echo "Rebuilding: $image_name"
	    	sudo docker rmi $image_name
	   fi
	   $KALAN_DIR/src/kbuildimage.sh $image_name

   fi

   if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname ]];then

	if sudo docker history -q $image_name 2>&1 >/dev/null; then
	    	echo "image Ok: $image_name exists in docker cache"
	else
		echo "image $image_name does not exist in cache. Checking in kalan-data"
		if [[ -e $KALAN_DIR-data/docker-images/$image_name.tar ]];then
			echo "found $image_name -> loading tar to docker cache... "
			sudo docker load --input $KALAN_DIR-data/docker-images/$image_name.tar
		else
			$KALAN_DIR/src/kbuildimage.sh $image_name
	    	fi
	fi
      	if [[ -z "$src_w2papps" ]];then
        	src_w2papps="$KALAN_DIR/dockerfiles/k-w2p/kalan-container/web2py/applications"
	fi
      	if [[ -e $src_w2papps/__init__.py ]];then
      		if sudo docker history -q $image_name 2>&1 >/dev/null; then
		    	echo "image Ok: $dockerfile exists in docker cache"
		        provision_appfolder=$KALAN_PROVISIONS_DIR/$provisionname/applications
		        mkdir -p $provision_appfolder
		        cp -rf $src_w2papps $KALAN_PROVISIONS_DIR/$provisionname/
		        echo "$image_name" > $KALAN_PROVISIONS_DIR/$provisionname/image_name
		        sudo docker create \
		        -v $provision_appfolder:$container_appfolder \
		        --name $provisionname-provision ubuntu:14.04.3
			if [ $? -eq 0 ]; then
				sudo docker run -p 8443:8443 -p 8888:8888 \
				--volumes-from $provisionname-provision -d \
				--entrypoint /usr/bin/python \
				--name $provisionname \
				$image_name \
				/var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8888 -a "<recycle>"
				
				sudo docker exec $provisionname chown -R kalan:kalan /var/kalan-container/web2py/applications
			else
				echo "Failed creating new provision for data container: $provisionname-provision"
			fi
		
			provisioncreated=true;
		else
		       echo "Failed creating new provision. Image $image_name is not in cache"
		fi
      	else
         	echo "There is no valid w2p apps folder at $src_w2papps"
      	fi

   else
      if [[ "$src_w2papps" == "--remove" ]];then
         echo "removing provision $provisionname"
         sudo docker stop $provisionname
         sudo docker rm -v $provisionname
         sudo docker rm -v $provisionname-provision
         if [ -d $KALAN_PROVISIONS_DIR/$provisionname ];then
            sudo rm -rf $KALAN_PROVISIONS_DIR/$provisionname
         else
            echo "error removing provision $KALAN_PROVISIONS_DIR/$provisionname"
         fi
      else
         echo "There is previous prevision with name $provisionname"
         echo "folder: $KALAN_PROVISIONS_DIR/$provisionname"
         ls $KALAN_PROVISIONS_DIR
         echo "apps folder: $src_w2papps"
      fi
   fi
}

main "$@"
