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
    
        if [[ ! -d $img_dir ]];then
        	mkdir -p $img_dir
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
    	  		    echo "image: $imgfound"
    	  		fi
	        done            
            if [[ ! -e $img_dir/$provisionname_httpd.tar ]];then
                echo "Saving $provisionname_httpd image en $img_dir "
                sudo docker save -o $img_dir/$provisionname_httpd.tar kw2p_httpd
            fi
            if [[ ! -e $img_dir/k-w2p.tar ]];then
                echo "Saving k-w2p image in $img_dir "
                sudo docker save -o $img_dir/k-w2p.tar k-w2p
            fi
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
