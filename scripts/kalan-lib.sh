NORMAL=`echo "\033[m"`
MENU=`echo "\033[36m"` #Blue
NUMBER=`echo "\033[33m"` #yellow
FGRED=`echo "\033[41m"`
RED_TEXT=`echo "\033[31m"`
ENTER_LINE=`echo "\033[33m"`
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
archivo="$3"
nuevacad="$2"
buscar="$1"
temporal="$archivo.tmp.kalan"
listalineas=$(cat $archivo)
if [[ !  -z  $listalineas  ]];then
#echo "reemplazando lineas existentes con:"
#echo "$nuevacad"
>$temporal
while read -r linea; do
if [[ $linea == *"$buscar"* ]];then
  #echo "... $linea ..."
  echo "$nuevacad" >> $temporal;
else
  echo "$linea" >> $temporal;

fi
done <<< "$listalineas"
    cat $temporal > $archivo
rm -rf $temporal
else
echo "agregando nueva linea $nuevacad"
echo $nuevacad>>$archivo
fi
}
function versionOS {
 rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)
}
function kalan-var {
   if [[ -z $2 ]];then
      sed "y/ ,/\n\n/;/^$1/P;D" </opt/kalan-data/conf/kalan.conf | awk -F= '{print $NF}'
   else
      replaceLinesThanContain "$1" "$1=$2" /opt/kalan-data/conf/kalan.conf
   fi

}

function pruebaLib {
   echo "Libreria Importada OK"
   echo $(versionOS)
}
function doublePassword {
pwOk=No
mensaje=""
while true
do
   PW=$(whiptail --nocancel --title "$1" --passwordbox "$mensaje
Teclee una clave y ENTER para continuar" 10 50 3>&1 1>&2 2>&3)

   PW2=$(whiptail --nocancel --title "$1" --passwordbox "Teclee nuevamente la clave y ENTER para continuar." 10 40 3>&1 1>&2 2>&3)
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