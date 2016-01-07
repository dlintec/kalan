#!/bin/bash
#/var/kalan/scripts/kprovision.sh
main() {
   KALAN_PROVISIONS_DIR="/var/kalan-data/provisions"
   provisionname="$1";shift;
   src_w2papps="$1";shift;
   provisioncreated=false;
   container_appfolder="/var/kalan-container/web2py/applications"
   if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname ]];then
      if [[ -z "$src_w2papps" ]];then
         src_w2papps="/var/kalan/dockerfiles/k-w2p/kalan-container/web2py/applications"
      fi
      if [[ -e $src_w2papps/__init__.py ]];then
         provision_appfolder=$KALAN_PROVISIONS_DIR/$provisionname/applications
         mkdir -p $provision_appfolder
         cp -rf $src_w2papps $KALAN_PROVISIONS_DIR/$provisionname/
         docker create \
            -v $provision_appfolder:$container_appfolder \
            --name $provisionname-provision ubuntu:14.04.3
            if [ $? -eq 0 ]; then
               docker run -p 8443:8443 -p 8888:8888 \
                  --volumes-from $provisionname-provision -d \
		            --entrypoint /usr/bin/python \
                  --name $provisionname \
                  k-w2p \
                  /var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8888 -a "<recycle>"

	            docker exec $provisionname chown -R kalan:kalan /var/kalan-container/web2py/applications
            else
               echo "Failed creating new provision for data container: $provisionname-provision"
            fi

         provisioncreated=true;
      else
         echo "There is no valid w2p apps folder at $src_w2papps"
      fi

   else
      if [[ "$src_w2papps" == "--remove" ]];then
         echo "removin provision $provisionname"
         docker stop $provisionname
         docker rm -v $provisionname
         docker rm -v $provisionname-provision
         if [ -d $KALAN_PROVISIONS_DIR/$provisionname ];then
            rm -rf $KALAN_PROVISIONS_DIR/$provisionname
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
