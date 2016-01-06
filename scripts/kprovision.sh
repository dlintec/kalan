#!/bin/bash
#/opt/kalan/scripts/kprovision.sh
main() {
   KALAN_PROVISIONS_DIR="/opt/kalan-data/provisions"
   provisionname="$1";shift;
   src_w2papps="$1";shift;
   if [[ ! -d $KALAN_PROVISIONS_DIR/$provisionname ]];then
      if [[ -n "$src_w2papps" ]];then
         if [[ -e $src_w2papps/__init__.py ]];then
            mkdir -p $KALAN_PROVISIONS_DIR/$provisionname/applications
            cp -r $src_w2papps $KALAN_PROVISIONS_DIR/$provisionname/applications
         else
            echo "There is no valid w2p apps folder at $src_w2papps"
         fi
      else
         mkdir -p $KALAN_PROVISIONS_DIR/$provisionname/applications
      fi

      cd $KALAN_PROVISIONS_DIR/$provisionname

   else
      echo "There is previous provision with name $provisionname"
      echo "folder: $KALAN_PROVISIONS_DIR/$provisionname"
      ls $KALAN_PROVISIONS_DIR
      echo "apps folder: $src_w2papps"
   fi
}

main "$@"
