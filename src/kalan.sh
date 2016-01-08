#!/bin/bash
main() {
   source ~/kalan/src/kalan-lib.sh
   echo "kalan: Hola!"
   for arg in "$@" ; do
       case "$arg" in
         -a)
           alpha=$2
           shift
           ;;
         -b)
           bravo=$2
           shift
           ;;
         -c)
           charlie=$2
           shift
           ;;
        esac
   done
   echo "a = $alpha"
   echo "b = $bravo"
   echo "c = $charle"
   echo $(get_package_manager)

}

main "$@"
