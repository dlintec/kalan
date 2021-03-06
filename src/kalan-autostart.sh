#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
#export supermode="dialog" && source easybashgui
source easybashgui
 . ~/.bashrc
 theip=$(get-ip-address)
clear
kecho "Welcome $KALAN_USER"
if [[ -e $KALAN_DIR-data/conf/updates ]];then
  sudo echo "  we need your superuser powers to start services"
  $KALAN_DIR/src/kconfigautostart.sh
  #$KALAN_DIR/src/kprovision.sh kalan --remove
  clear
  kecho "Welcome $KALAN_USER"
  #
  $KALAN_DIR/src/kconfigiptables.sh
  kalan_running=$(sudo docker ps | grep "kalan_")
  if [[ -z "$kalan_running" ]];then
    echo "Starting kprovision.sh kalan"
    $KALAN_DIR/src/kprovision.sh kalan 
  else
    echo "Kalan containers running:"
    echo "$kalan_running"
  fi
  #wait_seconds 10
  #exec x-www-browser https://localhost:8443
  echo "--------------------------------------------------"
  echo "Connect with your browser to https://localhost "
  echo "  This system also has the following IPs:"
  echo "$theip"
  
  echo "Press enter to close this window"
  read CONFIRM
else
  echo "  Please choose an option from the dialog I just opened"
  op_install="Clone kalan in new system"
  op_start="Start using kalan right now!"
  menu  "$op_start" "$op_install"
  installoption="$(cat ${dir_tmp}/${file_tmp})"  
  rm -f ${dir_tmp}/${file_tmp}
  if [[ $installoption == "$op_install"* ]];then

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
      gksu --disable-grab gparted &>/dev/null
      clear
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
      gksu --disable-grab  systemback &>/dev/null
      sudo mkdir -p /media/$(whoami)/SB@
      sudo mount -L SB@ /media/$(whoami)/SB@
      newuser=$(ls /media/$(whoami)/SB@/home)
      if [[ -d /media/$(whoami)/SB@/home/$newuser/kalan-data/conf ]];then
          echo "Added by installation" >> /media/$(whoami)/SB@/home/$newuser/kalan-data/conf/updates
          chmod 775 /media/$(whoami)/SB@/home/$newuser/kalan-data/conf/updates
       
cat << EOFKALANSCRIPT > /media/$(whoami)/SB@/home/$newuser/.config/autostart/kalan-autostart.desktop
[Desktop Entry]
Type=Application
Exec="/home/$newuser/kalan/src/kalan-autostart.sh"
Hidden=false
Terminal=true
Name=kalan-autostart
Comment=Startin containers
EOFKALANSCRIPT

          chmod 775 /media/$(whoami)/SB@/home/$newuser/.config/autostart/kalan-autostart.desktop
      fi
        #sudo blkid -c /dev/null

      clear
      kecho "Ok. Process over"
  else
       echo "Added by Autostart" >> $KALAN_DIR-data/conf/updates

  fi
  echo "Press enter to close this window"
  read CONFIRM
fi
