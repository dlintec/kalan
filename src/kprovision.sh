#!/bin/bash
#~/kalan/src/kprovision.sh
main() {
provisionname="$1";shift
rebuild="false"
deleteprovision="false"
runprovision="false"
include_proxy="false"
containername="$provisionname"
for arg in "$@" ; do
       case "$arg" in
         run)
           provisionname=$2
           runprovision="true"
           shift
           ;;
         +httpd)
           include_proxy="false"
           shift
           ;;

         -n)
           containername=$2
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
         --admin)
           adminauth=$2
           shift
           ;;
         --remove)
           src_w2papps="--remove"
           shift
           ;;
         --delete)
           src_w2papps="--remove"
           deleteprovision="true"
           shift
           ;;
         --rebuild)
           rebuild="true"
           shift
           ;;
        esac
done
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"

KALAN_PROVISIONS_DIR="$KALAN_DIR-data/provisions"
provisioncreated="false";
container_appfolder="/var/kalan-container/web2py/applications"
container_sslfolder="/var/kalan-container/ssl"
provision_appfolder=$KALAN_PROVISIONS_DIR/$provisionname/kalan-container/web2py/applications
provision_sslfolder=$KALAN_PROVISIONS_DIR/$provisionname/kalan-container/ssl

ssl_folder="/var/kalan-container/ssl"
if [[ -z "$image_name" ]];then
	image_name="k-w2p"
fi
echo "name  = $provisionname"
echo "image = $image_name"
echo "apps  = $src_w2papps"
provision_image_folder=$KALAN_PROVISIONS_DIR/$provisionname/kalan-container/$image_name
container_image_folder="/var/kalan-container/$image_name"
if [[ "$image_name" == "k-w2p" ]];then
    container_image_folder="/var/kalan-container/web2py"
fi
if [[ "$src_w2papps" == "--remove" ]];then
	 echo "removing provision $provisionname"
	 sudo docker stop $provisionname
	 sudo docker rm -v $provisionname
	 sudo docker rm -v $provisionname-$image_name
	 if [[ "$deleteprovision" == "true" ]];then
		 sudo docker rm -v $provisionname-data
		 if [ -d $KALAN_PROVISIONS_DIR/$provisionname ];then
		    sudo rm -rf $KALAN_PROVISIONS_DIR/$provisionname
		 else
		   echo "error removing provision $KALAN_PROVISIONS_DIR/$provisionname"
		 fi
	 fi
else

	if [[ "$rebuild" == "true" ]];then
	   echo "rebuilding..."
	   #$KALAN_DIR/src/kprovision.sh $provisionname --remove
	   if sudo docker history -q $image_name 2>&1 >/dev/null; then
	    	echo "Rebuilding: $image_name"
	    	if [[ -e $KALAN_DIR-data/docker-images/$image_name.tar ]];then
	    		now=$(date +"%Y.%m.%d.%S.%N")
			filename="$KALAN_DIR-data/docker-images/$image_name-$now.tar"
			mv $KALAN_DIR-data/docker-images/$image_name.tar $filename
		fi
	    	sudo docker rmi $image_name
	   fi
	   exit
	fi
	
	if sudo docker history -q $image_name 2>&1 >/dev/null; then
	    	echo "Check image: $image_name exists in docker cache"
	else
		echo "image $image_name does not exist in cache. Checking in kalan-data"
		if [[ -e $KALAN_DIR-data/docker-images/$image_name.tar ]];then
			echo "found $image_name -> loading tar to docker cache... "
			sudo docker load --input $KALAN_DIR-data/docker-images/$image_name.tar
		else
			$KALAN_DIR/src/kbuildimage.sh $image_name
	    	fi
	fi
	   
	if [[ (! -d $provision_image_folder )  ]];then
	
	      	if sudo docker history -q $image_name 2>&1 >/dev/null; then
		    	echo "image Ok: $image_name exists in docker cache"
		        mkdir -p $provision_image_folder
			provisioncreated="true";
 			echo "$image_name" > $provision_image_folder
		else
		       echo "Failed creating new provision. Image $image_name is not in cache"
		fi
	
	
	else
		provisioncreated="true";
	fi
	
	if [[ "$provisioncreated"=="true" ]];then
		echo "Provision OK"
		#-u 999:999
	        sudo docker run  \
	                -v $provision_image_folder:$container_image_folder \
	                --name $provisionname-$image_name $image_name echo "creating data container for $image_name"
			
		#-u kcontainer:kcontainer \
		if [ $? -eq 0 ]; then
			par1="init"
			par2=""
			if [[ -n "$adminauth" ]];then
				par1="initadmin"
				par2="$adminauth"
			fi
			echo "Starting on mode : $par1"
			sudo docker run -p 8443:8443 -p 8888:8888 -d\
				--volumes-from $provisionname-$image_name \
				--name $containername \
				$image_name \
				$par1 $par2
		
		fi
	fi
	
fi


}

main "$@"
