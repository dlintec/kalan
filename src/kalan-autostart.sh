#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
#export supermode="dialog" && source easybashgui
source easybashgui
clear
kecho "Welcome $KALAN_USER"
if [[ -e $KALAN_DIR-data/conf/updates ]];then
  sudo echo "  we need your superuser powers to start services"
  kprovision kalan --remove
  clear
  kecho "Welcome $KALAN_USER"
  kprovision kalan --admin admin
  
  #wait_seconds 10
  #exec x-www-browser https://localhost:8443
  clear
  kecho "Connect with your browser to https://localhost:8443"
  echo "  This system also has the following IPs:"
  echo ""
  get-ip-address
  echo "Press enter to close this window"
  read CONFIRM
else
  echo "  Please choose an option from the dialog I just opened"
  op_install="Clone kalan in new system"
  op_start="Start using kalan right now!"
  menu  "$op_start" "$op_install"
  installoption="$(cat ${dir_tmp}/${file_tmp})"  
  rm -f ${dir_tmp}/${file_tmp}
  case "$installoption" in
     $op_install)
      clear
      kecho "We are ready to start installation ;)"
      mssg1='
      The process needs 2 steps: 
       - Create partitions and volumes in new system
       - Select type of Install and restart
      ---------------------------------------------------------------
      I am opening Gparted for you...may need password.
      ---------------------------------------------------------------
      In Gparted, create partitions and volumes in new system:
      
       - Select the destination drive  for the install
       - From the menu use Device/Create partition table
       - select MSDOS for the type
       - create at least 2 partitions (you can create as needed for LVM): 
          1 ext4 for system and mounts
          1 swap (equal or bigger than RAM)
       - Apply changes (<- button) and close GParted to continue...
      '
      echo "$mssg1"
      gksu gparted &>/dev/null
      clear
      kecho "Now, select the options to install ;)"
      mssg2='
      ---------------------------------------------------------------
       /\  | ._ _   _   _ _|_   _|_ o ._  o  _ |_   _   _| 
      /--\ | | | | (_) _>  |_    |  | | | | _> | | (/_ (_| 
      I am opening systemback for you...may need password.
      ---------------------------------------------------------------
      In systemback, select "System install" :
      
      - Fill user information. Click "Next" (enabled when all valid) 
      - Assign the partitions to volume mounts and swap
        (use the <- arrow button to assign partitions to mount points)
      - Enable the "Include the user data files" Option 
      - Click next and start installation.
      - Restart the system when systemback finishes.
      '
      echo "$mssg2" 
       gksu systemback &>/dev/null
      clear
      kecho "Now, select the options to install ;)"

       ;;
     $op_start)
       echo ""
       ;;
  esac
  echo "Press enter to close this window"
  read CONFIRM
fi
