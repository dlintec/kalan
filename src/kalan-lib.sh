NORMAL=`echo "\033[m"`
MENU=`echo "\033[36m"` #Blue
NUMBER=`echo "\033[33m"` #yellow
FGRED=`echo "\033[41m"`
RED_TEXT=`echo "\033[31m"`
ENTER_LINE=`echo "\033[33m"`
function kecho {
  echo ""
  echo "  |_/ /\ |   /\ |\ | "
  echo "  | \/--\|__/--\| \| : $1"
  #echo '  |  _ | _  _ '
  #echo "  |<(_||(_|| | : $1"
  echo ""

}
function reemplazarEnArch {
  sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}
function get_package_manager {
   declare -A osInfo;
   osInfo[/etc/redhat-release]=yum
   osInfo[/etc/arch-release]=pacman
   osInfo[/etc/gentoo-release]=emerge
   osInfo[/etc/SuSE-release]=zypp
   osInfo[/etc/debian_version]=apt-get
   PACKAGE_MANAGER="yum"
   for f in ${!osInfo[@]}
   do
       if [[ -f $f ]];then
           PACKAGE_MANAGER=${osInfo[$f]}

       fi
   done
   export PACKAGE_MANAGER
   echo $PACKAGE_MANAGER
}
function replaceLinesThanContain {
  usesudo="$4"
  archivo="$3"
  nuevacad="$2"
  buscar="$1"
  temporal="$archivo.tmp.kalan"
  listalineas=$(cat $archivo)
  if [[ !  -z  $listalineas  ]];then
    #echo "reemplazando lineas existentes con:"
    #echo "$nuevacad"
    $usesudo >$temporal
    while read -r linea; do
    if [[ $linea == *"$buscar"* ]];then
      #echo "... $linea ..."
      $usesudo sh -c "echo '$nuevacad' >> $temporal;"
    else
      $usesudo sh -c "echo '$linea' >> $temporal;"
    
    fi
    done <<< "$listalineas"
    $usesudo cat $temporal > $archivo
    $usesudo rm -rf $temporal
  else
    echo "agregando nueva linea $nuevacad"
    $usesudo sh -c "echo $nuevacad>>$archivo"
  fi
}
function versionOS {
 rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)
}
function kalan-var {
   if [[ -z $2 ]];then
      sed "y/ ,/\n\n/;/^$1/P;D" <~/kalan-data/conf/kalan.conf | awk -F= '{print $NF}'
   else
      replaceLinesThanContain "$1" "$1=$2" ~/kalan-data/conf/kalan.conf
   fi

}

function pruebaLib {
   echo "Libreria Importada OK"
   echo $(versionOS)
}
function password_dialog {
pwOk=No
parametro="$2"
mensaje=""
while true
do
   PW=$(whiptail --nocancel --title "$1" --passwordbox "$mensaje
Teclee una clave y ENTER para continuar" 10 50 3>&1 1>&2 2>&3)
    if [[ "$parametro"=="double" ]];then
      PW2=$(whiptail --nocancel --title "$1" --passwordbox "Teclee nuevamente la clave y ENTER para continuar." 10 40 3>&1 1>&2 2>&3)
    else
      PW2="$PW"
    fi
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      if [ "$PW" == "$PW2" ];then
        pwOk="ok"
        echo "$PW"
        return
      else
        mensaje="ERROR: Las claves no coinciden. "
      fi
    else
      echo "error"
      return
    fi
done
}
