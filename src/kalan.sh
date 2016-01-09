#!/bin/bash
main() {
  KALAN_USER="$(who am i | awk '{print $1}')"
   source ~/kalan/src/kalan-lib.sh
   export supermode="dialog" && source easybashgui
   #_fselect
   #file="$(0< "${dir_tmp}/${file_tmp}" )"
   #echo $file
   #echo password | sudo -S -H -u kalan bash -c 'echo "I am $USER, with uid $UID"'
   input 3 "Username" "root" "IP address" "192.168.0.1" "Destination directory" "/tmp"
   IFS=$'\n' ; choices=( $(0< "${dir_tmp}/${file_tmp}" ) ) ; IFS=$' \t\n'
   user="${choices[0]}"
   ip="${choices[1]}"
   dir="${choices[2]}"
   echo "Hola $KALAN_USER"
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
