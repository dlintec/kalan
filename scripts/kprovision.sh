#!/bin/bash
#/opt/kalan/scripts/kprovision.sh
main() {
   KALAN_PROVISIONS_DIR="/opt/kalan-data/provisions"
   provisionname="$1";shift;
   src_w2papps="$1";shift;
   provisioncreated=false;
   provision_applications=$KALAN_PROVISIONS_DIR/$provisionname/applications
   if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname ]];then
      if [[ -n "$src_w2papps" ]];then
         if [[ -e $src_w2papps/__init__.py ]];then
            mkdir -p $provision_applications
            cp -r $src_w2papps $provision_applications
            provisioncreated=true;
         else
            echo "There is no valid w2p apps folder at $src_w2papps"
         fi
      else
         mkdir -p $provision_applications
         provisioncreated=true;
      fi
      if [[ provisioncreated ]];then
         docker create \
            -v $provision_applications:/opt/k-w2p/web2py/applications \
            --name $provisionname-provision ubuntu
      fi
   else
      echo "There is previous prevision with name $provisionname"
      echo "folder: $KALAN_PROVISIONS_DIR/$provisionname"
      ls $KALAN_PROVISIONS_DIR
      echo "apps folder: $src_w2papps"
   fi
}

main "$@"
