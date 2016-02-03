#!/bin/bash
#~/kalan/src/kprovision.sh
main() {
provisionname="$1";shift
rebuild="false"
deleteprovision="false"
runprovision="false"
include_proxy="false"

containername=""
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
if [[ -z "$image_name" ]];then
	image_name="k-w2p"
fi
if [[ -z "$containername" ]];then
	containername="$image_name"
fi
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"

KALAN_PROVISIONS_DIR="$KALAN_DIR-data/provisions"
provisioncreated="false";
container_appfolder="/var/kalan-container/web2py/applications"
container_sslfolder="/var/kalan-container/ssl"
provision_appfolder=$KALAN_PROVISIONS_DIR/$provisionname/kalan-container/web2py/applications
provision_sslfolder=$KALAN_PROVISIONS_DIR/$provisionname/kalan-container/ssl

ssl_folder="/var/kalan-container/ssl"

echo "name  = $provisionname"
echo "image = $image_name"
echo "apps  = $src_w2papps"
provision_image_folder=$KALAN_PROVISIONS_DIR/$provisionname/kalan-container/$image_name
container_image_folder="/var/kalan-container/$image_name"
provision_log_folder=$KALAN_PROVISIONS_DIR/$provisionname/httpd/logs
if [[ "$src_w2papps" == "--remove" ]];then
	 echo "removing provision $provisionname"
	 if [[ -e $KALAN_DIR/dockerfiles/$image_name/docker-compose.yml ]];then
	        cd $KALAN_DIR/dockerfiles/$image_name
	 	sudo docker-compose stop
	 else
	 	sudo docker stop $containername
		sudo docker rm -v $containername
		sudo docker rm -v $image_name-data

	 fi
	 if [[ "$deleteprovision" == "true" ]];then
		
		 if [ -d $KALAN_PROVISIONS_DIR/$provisionname ];then
		    sudo rm -rf $KALAN_PROVISIONS_DIR/$provisionname
		 else
		   echo "error removing provision $KALAN_PROVISIONS_DIR/$provisionname"
		 fi
	 fi
else
	if sudo docker history -q ubuntu 2>&1 >/dev/null; then
	    	echo "Check image: ubuntu Ok"
	else
		echo "image kalan-base  does not exist in cache. Checking in kalan-data"
		if [[ -e $KALAN_DIR-data/docker-images/kalan-base.tar ]];then
			echo "found kalan-base ubuntu -> loading tar to docker cache... "
			sudo docker load --input $KALAN_DIR-data/docker-images/kalan-base.tar
	    	fi
	fi
	if sudo docker history -q kw2p_httpd 2>&1 >/dev/null; then
	    	echo "Check image: kw2p_httpd Ok"
	else
		echo "image kw2p_httpd  does not exist in cache. Checking in kalan-data"
		if [[ -e $KALAN_DIR-data/docker-images/kw2p_httpd.tar ]];then
			echo "found kw2p_httpd -> loading tar to docker cache... "
			sudo docker load --input $KALAN_DIR-data/docker-images/kw2p_httpd.tar
	    	fi
	fi
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
	   
	if [[ (! -d $provision_image_folder/containers )  ]];then
	
	      	if sudo docker history -q $image_name 2>&1 >/dev/null; then
		    	echo "image Ok: $image_name exists in docker cache"
		        mkdir -p $provision_image_folder/containers
		        
			provisioncreated="true";
 			
		else
		       echo "Failed creating new provision. Image $image_name is not in cache"
		fi
	
	
	else

		provisioncreated="true";
	fi
	
	if [[ "$provisioncreated"=="true" ]];then
		echo "Provision OK"
		#-u 999:999
		if [[ -e $KALAN_DIR/dockerfiles/$image_name/docker-compose.yml ]];then
			if [[ (! -d $provision_log_folder )  ]];then
				mkdir -p $provision_log_folder
			fi

		       cd $KALAN_DIR/dockerfiles/$image_name
		       sudo docker-compose up -d
	               RESULT=$?
		       if [ $RESULT -eq 0 ]; then
			        img_dir="$KALAN_DIR-data/docker-images"
			        if [[ ! -d $img_dir ]];then
			           mkdir -p $img_dir
			        fi
			        if [[ ! -e $img_dir/kw2p_httpd.tar ]];then
			            echo "Saving kw2p_httpd image en $img_dir "
			            sudo docker save -o $img_dir/kw2p_httpd.tar kw2p_httpd
			        fi
			        if [[ ! -e $img_dir/k-w2p.tar ]];then
			            echo "Saving k-w2p image in $img_dir "
			            sudo docker save -o $img_dir/k-w2p.tar k-w2p
			        fi
				if [[ ! -e $img_dir/kalan-base.tar ]];then
					echo "Saving kalan-base image en $img_dir "
					sudo docker save -o $img_dir/kalan-base.tar ubuntu
				fi

			        echo success
		       else
			        echo failed
		       fi
		else
		        sudo docker run  \
		                -v $provision_image_folder:$container_image_folder \
		                --name $image_name-data $image_name echo "creating data container for $image_name"
				
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
					--volumes-from $provisionname-data \
					--name $containername \
					$image_name \
					$par1 $par2
			         echo "$image_name" > $provision_image_folder/containers/$containername
			fi
		fi
	fi
	
fi


}

main "$@"
