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

if [[ "$src_w2papps" == "--remove" ]];then
	 echo "removing provision $provisionname"
	 if [[ -e $KALAN_DIR/dockerfiles/$provisionname/docker-compose.yml ]];then
	        cd $KALAN_DIR/dockerfiles/$provisionname
	 	sudo docker-compose stop
	 fi
	 if [[ "$deleteprovision" == "true" ]];then
		
		 if [ -d $KALAN_PROVISIONS_DIR/$provisionname ];then
		    sudo rm -rf $KALAN_PROVISIONS_DIR/$provisionname
		 else
		   echo "error removing provision $KALAN_PROVISIONS_DIR/$provisionname"
		 fi
	 fi
else 
    if [[ (! -d $KALAN_PROVISIONS_DIR )  ]];then
      mkdir -p $KALAN_PROVISIONS_DIR
    fi
    if [[ -e $KALAN_DIR/dockerfiles/$provisionname/docker-compose.yml ]];then
        img_dir="$KALAN_PROVISIONS_DIR/$provisionname/images"
        if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname/data ]];then
        	mkdir -p $KALAN_PROVISIONS_DIR/$provisionname/data
        fi	
        if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname/logs ]];then
        	mkdir -p $KALAN_PROVISIONS_DIR/$provisionname/logs
        fi	
    
        if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname/images ]];then
        	mkdir -p $KALAN_PROVISIONS_DIR/$provisionname/images
        else
        	images_avail=$(ls $KALAN_PROVISIONS_DIR/$provisionname/images)
   		if [[ -n "$images_avail" ]];then
   		    for line in $images_avail ; do
             		echo "$line available"
             		imgname=$(echo "$line" | cut -d "." -f1)
             		echo "$imgname"
             		imagesincache=$(sudo docker images | grep $imgname)
             		if [[ -n "imagesincache" ]];then
             		   echo "image $imgname already in cache"
             		else
             		   echo "loading image $imgname to cache. This may take a while. Please wait..."
             		   sudo docker load --input $KALAN_PROVISIONS_DIR/$provisionname/images/$line
             		fi
             		   
             	    done
   		fi

        fi	
        cd $KALAN_DIR/dockerfiles/$provisionname
        sudo docker-compose up -d
        RESULT=$?
        if [ $RESULT -eq 0 ]; then
            if [[ ! -d $img_dir ]];then
               mkdir -p $img_dir
            fi
	        provisionstr=${provisionname}_
	        provisionimages=$(sudo docker images | grep $provisionstr)
	        for imgfound in $provisionimages; do
	    	        if [[ ( "$imgfound" == "$provisionstr"* ) ]];then
	    	  	   echo "image:  $imgfound"	    
		            if [[ ! -e $img_dir/$imgfound.tar ]];then
		                echo "Saving $imgfound image in $img_dir "
		                sudo docker save -o $img_dir/$imgfound.tar $imgfound
		            fi
	    	  	fi
	    	  
	        done            
        	if [[ ! -e $img_dir/ubuntu.tar ]];then
        		echo "Saving ubuntu image en $img_dir "
        		sudo docker save -o $img_dir/ubuntu.tar ubuntu
        	fi
        
            echo success
        else
            echo failed
        fi    
    fi
fi



}

main "$@"
