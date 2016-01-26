#!/bin/bash
#~/kalan/src/kprovision.sh
main() {
provisionname="$1";shift
rebuild="false"
deleteprovision="false"
runprovision="false"
for arg in "$@" ; do
       case "$arg" in
         run)
           provisionname=$2
           runprovision="true"
           shift
           ;;

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
echo "name  = $provisionname"
echo "image = $image_name"
echo "apps  = $src_w2papps"
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

if [[ "$src_w2papps" == "--remove" ]];then
	 echo "removing provision $provisionname"
	 sudo docker stop $provisionname
	 sudo docker rm -v $provisionname
	 sudo docker rm -v $provisionname-data
	 if [[ "$deleteprovision" == "true" ]];then
		 sudo docker rm -v $provisionname-provision
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
	   
	if [[ (! -e $KALAN_PROVISIONS_DIR/$provisionname/image_name )  ]];then
	
	      	if sudo docker history -q $image_name 2>&1 >/dev/null; then
		    	echo "image Ok: $image_name exists in docker cache"
		        mkdir -p $provision_appfolder
		        
		       
			if [[ ($? -eq 0) && (! -e $KALAN_PROVISIONS_DIR/$provisionname/image_name ) ]]; then
			        sudo docker run -u 999:999 \
			                -v $provision_appfolder:$container_appfolder \
			                --name $provisionname-data $image_name echo "creating data container"
				#sudo docker exec $provisionname chown -R kcontainer:kcontainer /var/kalan-container/web2py
				echo "starting up config container"
				sudo docker run -p 8443:8443 -p 8888:8888 -d\
				--volumes-from $provisionname-data \
				--name $provisionname-config \
				$image_name \
				init
				#/var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8888 -a "<recycle>"
				
				#sudo docker exec $provisionname-config cp -a $container_appfolder-backup/. /var/kalan-container/web2py/applications/
				#sudo docker exec $provisionname-config chown -R 999:999 /var/kalan-container
				echo "stoping config container"
				sudo docker stop $provisionname-config
				sudo docker rm -v $provisionname-config
				sudo docker rm -v $provisionname-data
				provisioncreated="true";
	 			echo "$image_name" > $KALAN_PROVISIONS_DIR/$provisionname/image_name
			else
				echo "Failed creating new provision for data container: $provisionname-provision"
			fi
		
			
		else
		       echo "Failed creating new provision. Image $image_name is not in cache"
		fi
	
	
	else
		provisioncreated="true";
		echo "There is previous prevision with name $provisionname"
		echo "folder: $KALAN_PROVISIONS_DIR/$provisionname"
		#ls $KALAN_PROVISIONS_DIR
		echo "apps folder: $src_w2papps"
		
	
	fi
	
	if [[ "$provisioncreated"=="true" ]];then
		echo "Starting container. Provision exists"
	        sudo docker run -u 999:999 \
	                -v $provision_appfolder:$container_appfolder \
	                --name $provisionname-data $image_name echo "creating data container"
		sudo docker run -p 8443:8443 -p 8888:8888 -d\
			--volumes-from $provisionname-data \
			--name $provisionname \
			$image_name \
			init
		if [ $? -eq 0 ]; then
			if [[ -n "$adminauth" ]];then
				echo "Starting admin interface"
				sudo docker exec -d $provisionname python /var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8443 -a "$adminauth" -k $container_sslfolder/self_signed.key -c $container_sslfolder/self_signed.cert
			fi
		fi
	fi
	
fi


}

main "$@"
