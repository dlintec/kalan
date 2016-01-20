#!/bin/bash
#~/kalan/src/kprovision.sh
main() {
provisionname="$1";shift
rebuild="false"
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
         --admin)
           adminauth=$2
           shift
           ;;
         --remove)
           src_w2papps="--remove"
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
   provisioncreated=false;
   container_appfolder="/var/kalan-container/web2py/applications"
   ssl_folder="/var/kalan-container/ssl"
   if [[ -z "$image_name" ]];then
	 image_name="k-w2p"
   fi
   

   if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname ]];then
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

      	if sudo docker history -q $image_name 2>&1 >/dev/null; then
	    	echo "image Ok: $dockerfile exists in docker cache"
	        provision_appfolder=$KALAN_PROVISIONS_DIR/$provisionname/kalan-container/web2py/applications
	        mkdir -p $provision_appfolder
	        echo "$image_name" > $KALAN_PROVISIONS_DIR/$provisionname/image_name

	        sudo docker run -u 999:999 \
	                -v $provision_appfolder:$container_appfolder \
	                --name $provisionname-provision $image_name cp -rf /var/kalan-container/web2py/applications-backup/*  /var/kalan-container/web2py/applications/

		if [ $? -eq 0 ]; then
			
			#sudo docker exec $provisionname chown -R kcontainer:kcontainer /var/kalan-container/web2py
			echo "starting up config container"
			sudo docker run -p 8443:8443 -p 8888:8888 -d\
			--volumes-from $provisionname-provision \
			--entrypoint /usr/bin/python \
			--name $provisionname-config \
			$image_name \
			/var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8888 -a "<recycle>"

			sudo docker exec $provisionname-config chown -R 999:999 /var/kalan-container
			
			if [[ -n "$adminauth" ]];then
				certCN="localhost.localdomain"
				sudo docker exec $provisionname-config mkdir -p $ssl_folder
				sudo docker exec $provisionname-config openssl genrsa -des3 -passout pass:x -out $ssl_folder/certif.pass.key 2048
				sudo docker exec $provisionname-config openssl rsa -passin pass:x -in $ssl_folder/certif.pass.key -out $ssl_folder/self_signed.key
				sudo docker exec $provisionname-config rm $container_appfolder/ssl/certif.pass.key
				sudo docker exec $provisionname-config openssl req -new -key $cssl_folder/self_signed.key -out $ssl_folder/self_signed.csr -subj "/C=MX/ST=Mexico/L=DF/O=seguraxes/OU=dlintec/CN=$certCN"
				sudo docker exec $provisionname-config openssl x509 -req -days 1000 -in $container_appfolder/ssl/self_signed.csr -signkey  $ssl_folder/self_signed.key -out $ssl_folder/self_signed.cert
				sudo docker exec $provisionname-config chmod -R 550 $ssl_folder
				sudo docker exec $provisionname-config chgrp -R 999 $ssl_folder
				#sudo docker exec $provisionname chown -R kcontainer:kcontainer /etc/w2p
				
				#sudo docker rm $provisionname-config
			fi
			echo "stoping config container"
			sudo docker stop $provisionname-config

			echo "Starting container"

			sudo docker run -p 8443:8443 -p 8888:8888 -d\
				--volumes-from $provisionname-provision \
				--entrypoint /usr/bin/python \
				--name $provisionname \
				$image_name \
				/var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8888 -a "<recycle>"

			if [[ -n "$adminauth" ]];then
				echo "Starting admin interface"
				sudo docker exec -d $provisionname python /var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8443 -a "$adminauth" -k $container_appfolder/ssl/self_signed.key -c $container_appfolder/ssl/self_signed.cert
			fi
		else
			echo "Failed creating new provision for data container: $provisionname-provision"
		fi
	
		provisioncreated=true;
	else
	       echo "Failed creating new provision. Image $image_name is not in cache"
	fi


   else
      if [[ "$src_w2papps" == "--remove" ]];then
         echo "removing provision $provisionname"
         sudo docker stop $provisionname
         sudo docker rm -v $provisionname
         sudo docker rm -v $provisionname-provision
         sudo docker rm -v $provisionname-config
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
