#!/bin/bash
main() {
PARAMETRO="$1"
KALAN_VERSION="1.2.3"
current_dir=`pwd`
## git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan;chmod +x /opt/kalan/kalan-instalacion.sh;/opt/kalan/kalan-instalacion.sh scripts
if [[ (-e /opt/kalan-data/conf/flag_postinstall) && ("$PARAMETRO" != "scripts") ]];then
    echo $(cat /opt/kalan-data/conf/flag_postinstall)
	if [ "$PARAMETRO" == "force" ];then
	   rm -f /opt/kalan-data/conf/flag_postinstall
	fi
	if [ "$PARAMETRO" == "forcefull" ];then
	   rm -f /opt/kalan-data/conf/flag_install
	   rm -f /opt/kalan-data/conf/flag_postinstall
	fi
else
clear
echo "______________________________________________________________________________"
echo " "
echo " "
echo "             Este programa realiza la configuracion inicial del"
echo "             sistema operativo para Kalan digital intelligence server"
echo "             Instalador $KALAN_VERSION"
echo " "
echo "=============================================================================="
echo "      AVISO: Bienvenidos"
echo "             "
echo "=============================================================================="
echo " "
echo " "

#####FUNCION##### f_create_scripts

function  f_create_scripts {

echo "Creando scripts"
if [ ! -d /opt/kalan/scripts/ ]; then
    mkdir -p /opt/kalan/scripts/
fi
if [ ! -d /opt/kalan/standard/ ]; then
    mkdir -p /opt/kalan/standard/
fi
if [ ! -d /opt/kalan-data/conf/ ]; then
    mkdir -p /opt/kalan-data/conf/
fi

if [ ! -e /opt/kalan-data/conf/kalan.conf ];then
kalan_hash=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16)
#####SCRIPT##### kalan.conf
cat << EOF > /opt/kalan-data/conf/kalan.conf
VERSION_ORIGINAL=$KALAN_VERSION
VERSION_ACTUAL=$KALAN_VERSION
URL_ACTUALIZACION=https://dlintec-inteligencia.com:8888/SG/static/act/kalan-actualizacion-web
DESTINO_PROXY_DEFAULT=http://localhost:8888
KALANPG_MD5=$kalan_hash
EOF
#####ENDSCRIPT##### kalan.conf
fi

#####SCRIPT##### kalan-registrar-script.sh
cat << 'EOFKALANSCRIPT' > /opt/kalan/scripts/kalan-registrar-script.sh
#!/bin/bash
cadena="$1"
nombrecompleto="${cadena##*/}"
extension="${nombrecompleto##*.}"
solonombre="${nombrecompleto%%.*}"
chmod +x $1
ln -sf $1 /usr/local/bin/$solonombre
EOFKALANSCRIPT
chmod +x /opt/kalan/scripts/kalan-registrar-script.sh
ln -sf /opt/kalan/scripts/kalan-registrar-script.sh /usr/local/bin/kalan-registrar-script
#####ENDSCRIPT##### kalan-registrar-script.sh

#####SCRIPT##### kalan-menu
scriptname="/opt/kalan/scripts/kalan-menu.sh"
cat << 'EOF' > $scriptname
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
VERSION_ACTUAL=$(kalan-var "VERSION_ACTUAL")
while [ opt != '0' ]
do
opt=$(dialog --no-lines --stdout --no-cancel --menu \
"KALAN v$VERSION_ACTUAL
A la orden $(whoami)
_____________________________________________________" \
16 60 \
10 \
0 "Salir a linea de comandos                       " \
1 "Ajustes de Red                                  " \
2 "Servicios y Seguridad                           " \
3 "Actualizaciones                                 " \
4 "Reiniciar equipo                                " \
5 "Apagar equipo                                   " \
6 "Cerrar Sesion                                   "
)
retopt=$?
case $retopt in

  0) case $opt in

        0)  echo "Saliendo";
		    clear ;
			reset;
			clear ;
			echo "Gracias."
		    exit
		;;

        1)  clear;
		    /opt/kalan/scripts/kalan-menu-red.sh
        ;;

        2)  clear;
			/opt/kalan/scripts/kalan-menu-servicios.sh
        ;;
        3)  clear;
  			/opt/kalan/scripts/kalan-actualizar.sh
        ;;

        4) echo " "
		   dialog --no-lines  --defaultno --title " " --clear --yesno "Esta Seguro de REINICIAR el equipo?" 5 40
			case $? in
				  0)clear;
					sudo systemctl reboot;
                    exit;;
				  1)
					echo "No.";
					clear;;
				  255)
					echo "ESC.";;
			esac
        ;;

        5)  echo " "

		dialog --no-lines  --defaultno --title " " --yesno "Esta Seguro de APAGAR el equipo?" 5 40
				case $? in
				  0)clear;
					sudo systemctl poweroff;
                    exit;;
				  1)
					echo "No.";
					clear;;
				  255)
					echo "ESC.";;
				esac
        ;;
        6)kill -HUP `pgrep -s 0 -o`
		exit;
        ;;
        0)clear;
		exit;
        ;;

        x)exit;
        ;;
        7)exit;
        ;;

        \n)clear;
		exit;
        ;;

        *)clear;

        ;;
   esac ;;
   *)clear; exit;;
esac
echo $opt
done
EOF
/opt/kalan/scripts/kalan-registrar-script.sh $scriptname

#####ENDSCRIPT##### kalan-menu

#####SCRIPT##### kalan-lib.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-lib.sh
NORMAL=`echo "\033[m"`
MENU=`echo "\033[36m"` #Blue
NUMBER=`echo "\033[33m"` #yellow
FGRED=`echo "\033[41m"`
RED_TEXT=`echo "\033[31m"`
ENTER_LINE=`echo "\033[33m"`
function reemplazarEnArch {
  sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
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
EOF
#####ENDSCRIPT##### kalan-lib.sh

#####SCRIPT##### get-ip-address.sh
cat << 'EOF' > /opt/kalan/scripts/get-ip-address.sh
#!/bin/bash
#Agregado kalan
ip add | grep "inet " | grep -v "127.0.0.1" | awk '{ print $2 }' | awk -F'/' '{print $1}'
#FIN Agregado kalan
EOF
chmod +x /opt/kalan/scripts/get-ip-address.sh
ln -sf /opt/kalan/scripts/get-ip-address.sh /usr/local/bin/
#####ENDSCRIPT##### get-ip-address.sh

#####SCRIPT##### get-internet.sh
cat << 'EOF' > /opt/kalan/scripts/get-internet.sh
#!/bin/bash
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
    echo "1"
else
    echo "0"
fi
EOF
chmod +x /opt/kalan/scripts/get-internet.sh
ln -sf /opt/kalan/scripts/get-internet.sh /usr/local/bin/
ln -sf /opt/kalan/scripts/get-internet.sh /usr/local/bin/get-internet
#####ENDSCRIPT##### get-internet.sh

#####SCRIPT##### crear-usuarios.sh
cat << 'EOF' > /opt/kalan/scripts/crear-usuarios.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
if id -u "kalan" >/dev/null 2>&1; then
        echo "usuario kalan ya existe"
else
        echo "Creando Usuario kalan."
                useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
fi

if id -u "servidor" >/dev/null 2>&1; then
        echo "usuario servidor ya existe"
else
        echo "Creando Usuario servidor"
                useradd servidor
                echo "servidor ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/servidor
				clear
				echo "______________________________________________________________________________"
				echo " "
                echo "Introduzca la nueva clave de usuario servidor"
				echo "______________________________________________________________________________"
				PW_SERVIDOR=$(doublePassword "Nuevo superusuario -servidor-")
				clear
				echo "$PW_SERVIDOR" |passwd servidor --stdin
                echo "/opt/kalan/scripts/kalan-menu.sh" >> /home/servidor/.bashrc
                #echo "/opt/kalan/scripts/kalan-menu.sh" >> /root/.bashrc
fi

EOF
chmod +x /opt/kalan/scripts/crear-usuarios.sh
ln -sf /opt/kalan/scripts/crear-usuarios.sh /usr/local/bin/

#####SCRIPT##### crear-usuarios.sh

#####SCRIPT##### kalan-explorador.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-explorador.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
FILE=$(dialog --no-lines --title  "Registros" --stdout --title "Seleccione un archivo" --fselect $1 10 48)
echo $FILE
EOF
chmod +x /opt/kalan/scripts/kalan-explorador.sh
ln -sf /opt/kalan/scripts/kalan-explorador.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-explorado


#####SCRIPT##### ifup-local.sh
cat << 'EOF' > /opt/kalan/scripts/ifup-local.sh
#!/bin/bash
if [ "$1" = lo ]; then
    echo "SIN RED" >> /tmp/red
    #exit 0
else
	/opt/kalan/scripts/get-ip-address.sh >> /tmp/red
fi
EOF
chmod +x /opt/kalan/scripts/ifup-local.sh
ln -sf /opt/kalan/scripts/ifup-local.sh /sbin/
#####ENDSCRIPT##### ifup-local.sh


#####SCRIPT##### hosts.standard
#Respaldar si no existe respaldo original
if [ ! -e /etc/hosts.original ]; then
    cp /etc/hosts /etc/hosts.original
fi
cat << 'EOF' > /opt/kalan/standard/hosts.standard
#Agregado kalan
127.0.0.1   localhost ##KALAN_IP## ##KALAN_HOSTNAME## localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost ##KALAN_IP## ##KALAN_HOSTNAME## localhost.localdomain localhost6 localhost6.localdomain6
#FIN Agregado kalan
EOF

#####ENDSCRIPT##### hosts.standard



#####SCRIPT##### kalan-menu-servicios.sh

cat << 'EOF' > /opt/kalan/scripts/kalan-menu-servicios.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh

while [ opt != '0' ]
do

opt=$(dialog --no-lines --stdout --no-cancel --menu \
"Servicios y Seguridad
_____________________________________________________" \
20 70 \
10 \
0 "Regresar                                        " \
1 "Cambiar sistema a MODO PRODUCCION               " \
2 "Cambiar sistema a MODO MANTENIMIENTO            " \
3 "Archivo de configuraciones (CTRL+X para salir)  " \
4 "Ver Registros                                   " \
5 "Configurar WAF                                  " \
6 "Crear certificado TLS/SSL para servidor web     " \
7 "Usuarios                                        " \
8 "Clonar Sistema                                  "
)
retopt=$?
case $retopt in

   0) case $opt in

        1) echo " "
            clear


            echo -e   "${NUMBER}______________________________________________________________________${NORMAL}"
            echo -e   "${NORMAL}                                                                      ${NORMAL}"
            echo -e   "${NORMAL}   Ha solicitado pasar el equipo a modo PRODUCCION                    ${NORMAL}"
            echo -e   "${NORMAL}    -Se cambia puerto SSH de 22 a 2222                                ${NORMAL}"
            echo -e   "${NORMAL}    -Se desactiva sftp                                                ${NORMAL}"
            echo -e   "${NORMAL}    -Se desactiva acceso root que no sea local                        ${NORMAL}"
            echo -e   "${NORMAL}    -Se modifican las reglas del firewall para solo permitir          ${NORMAL}"
            echo -e   "${NORMAL}     los puertos 80,443,y 2222. Se cierrar puertos restantes          ${NORMAL}"
            echo -e   "${NUMBER}   Si prosigue es posible que tenga reiniciar la sesion               ${NORMAL}"
            echo -e   "${NUMBER}______________________________________________________________________${NORMAL}"
            echo -e   "${NORMAL}                                                                      ${NORMAL}"
            case $response in
			[sS][iI]|[sS])
               sudo /opt/kalan/scripts/kalan-hardening.sh
			   echo "Necesita reiniciar el equipo para que los cambios surtan efecto"
			   echo "pulse ENTER para continuar..."
			   read CONFIRM
            ;;
            *)  clear;
                ;;
            esac
        ;;

        2) echo " "
            clear
            echo -e      "${FGRED}                                                                         ${NORMAL}"
            echo -e      "${FGRED}   Ha solicitado pasar el equipo a modo MANTENIMIENTO                    ${NORMAL}"
            echo -e      "${FGRED}                                                                         ${NORMAL}"
            echo -e     "${NORMAL}                                                                         ${NORMAL}"
            echo -e     "${NORMAL}    -Cambio de puerto SSH de 2222 a 22                                   ${NORMAL}"
            echo -e     "${NORMAL}    -Se activa sftp y otros servicios                                    ${NORMAL}"
            echo -e     "${NORMAL}    -Se modifican las reglas del firewall para solor permitir            ${NORMAL}"
            echo -e     "${NORMAL}     los puertos 80,443,22 y 8080                                        ${NORMAL}"
            echo -e     "${NORMAL}                                                                         ${NORMAL}"
            echo -e   "${RED_TEXT}   NOTA: El modo mantenimiento no debe usarse para ambientes             ${NORMAL}"
            echo -e   "${RED_TEXT}   expuestos a redes que no son de confianza.                            ${NORMAL}"
            echo -e     "${NUMBER}   Si prosigue es posible que tenga reiniciar la sesion                  ${NORMAL}"
            echo -e     "${NUMBER}_________________________________________________________________________${NORMAL}"
            echo -e     "${NORMAL}                                                                         ${NORMAL}"
            echo -e     "${NORMAL}                                                                         ${NORMAL}"
            read -r -p         "   Esta Seguro de cambiar a modo MANTENIMIENTO? [s/N] " response
            case $response in
			[sS][iI]|[sS])
               sudo /opt/kalan/scripts/kalan-modo-mantenimiento.sh
			   echo "Necesita reiniciar el equipo para que los cambios surtan efecto"
			   echo "pulse ENTER para continuar..."
			   echo -e    "${NORMAL}   DEBE REINICIAR. ${RED_TEXT}Recuerde regresar a MODO PRODUCCION     ${NORMAL}"
			   read CONFIRM
            ;;
            *)  clear;

                ;;
            esac
        ;;
        3)clear;
		   sudo nano /opt/kalan-data/conf/kalan.conf

		 ;;

        4)clear;
		FILE=$(sudo dialog --no-lines --title  "Registros" --stdout --title "Seleccione un archivo" --fselect /var/log/ 14 48)
		   sudo dialog --no-lines --title  "$FILE" --stdout --title "Seleccione un archivo" --textbox $FILE 100 200
        ;;
        5)sudo /op/kalan/scripts/configurar-waf
        ;;
        6)clear;
		echo "pulse CTRL+C para cancelar..."
		sudo /opt/kalan/scripts/kalan-crear-certificado
        ;;
        7)sudo /opt/kalan/scripts/kalan-menu-usuarios.sh
        ;;
        8)clear;
				dialog --no-lines  --defaultno --title "Clonar Sistema" --yesno "El proceso puede durar mucho y requerir espacio en disco. Esto depende de los paquetes y aplicaciones instalados. Esta Seguro de Clonar el Sistema?" 10 40
				case $? in
				  0)clear;
				    usr_home="$HOME"
					sudo /opt/kalan/scripts/kalan-clonar-sistema.sh $usr_home
					echo "Pulse ENTER para continuar..."
					read CONFIRM
                    exit;;
				  1)
					echo "No.";
					clear;;
				  255)
					echo "ESC.";;
				esac
        ;;

        0)clear;
		exit;
        ;;

        x)exit;
        ;;

        \n)clear;
		exit;
        ;;

        *)clear;
        ;;
   esac ;;
   *)clear; exit;;
esac
echo $opt
done
EOF
chmod +x /opt/kalan/scripts/kalan-menu-servicios.sh

ln -sf /opt/kalan/scripts/kalan-menu-servicios.sh /usr/local/bin/

#####ENDSCRIPT##### /opt/kalan/scripts/kalan-menu-servicios.sh

#####SCRIPT##### kalan-menu-red.sh

cat << 'EOF' > /opt/kalan/scripts/kalan-menu-red.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh


IP_ACTUAL=$(/opt/kalan/scripts/get-ip-address.sh)

HOST_ACTUAL=$(hostname)

while [ opt != '0' ]
do

opt=$(dialog --no-lines --stdout --no-cancel --menu \
"AJUSTES DE RED
IP actual:$IP_ACTUAL host:$HOST_ACTUAL
_____________________________________________________" \
14 70 \
7 \
0 "Regresar                                        " \
1 "Configurar IP y tarjeta de red                  " \
2 "Servicios de red                                " \
3 "Asignar $IP_ACTUAL $HOST_ACTUAL a servicios http"
)
retopt=$?
case $retopt in

   0)case $opt in
        1) clear;
            sudo /opt/kalan/scripts/configurar-red.sh
			sudo /opt/kalan/scripts/cambio-en-red.sh

			clear;

            ;;
        2) clear;
            sudo /opt/kalan/scripts/kalan-menu-servicios-red.sh
			sudo /opt/kalan/scripts/cambio-en-red.sh

            ;;
        3) clear;
         	sudo /opt/kalan/scripts/reemplazar-ip-en-scripts.sh $(hostname) $(get-ip-address.sh)
			echo -e " DEBE REINICIAR para que los cambios surtan efecto.${NORMAL}"
			echo " pulse ENTER para continuar..."
			read CONFIRM

        ;;

        6)clear;
		exit;
		;;
        x)clear;
		exit;
        ;;
        0)clear;
		exit;
        ;;

        \n)clear;
		exit;
        ;;

        *)clear;
        ;;

   esac ;;
   *)clear; exit;;
esac
echo $opt
done

EOF

chmod +x /opt/kalan/scripts/kalan-menu-red.sh
ln -sf /opt/kalan/scripts/kalan-menu-red.sh /usr/local/bin/

#####ENDSCRIPT##### /opt/kalan/scripts/kalan-menu-red.sh

#####SCRIPT##### kalan-menu-usuarios.sh

cat << 'EOF' > /opt/kalan/scripts/kalan-menu-usuarios.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh

while [ opt != '0' ]
do

opt=$(dialog --no-lines --stdout --no-cancel --menu \
"Servicios y Seguridad
_____________________________________________________" \
20 70 \
10 \
0 "Regresar                                        " \
1 "Cambiar clave de Administrador web              "
)
retopt=$?
case $retopt in

   0) case $opt in

        1)/opt/kalan/scripts/kalan-web2py-admin.sh
		clear;
		;;
        0)clear;
		exit;
        ;;

        x)exit;
        ;;

        \n)clear;
		exit;
        ;;

        *)clear;
        ;;
   esac ;;
   *)clear; exit;;
esac
echo $opt
done
EOF
chmod +x /opt/kalan/scripts/kalan-menu-usuarios.sh

ln -sf /opt/kalan/scripts/kalan-menu-usuarios.sh /usr/local/bin/

#####ENDSCRIPT##### /opt/kalan/scripts/kalan-menu-usuarios.sh





#####SCRIPT##### kalan-menu-servicios-red.sh

cat << 'EOF' > /opt/kalan/scripts/kalan-menu-servicios-red.sh
#!/bin/bash
echo "Aun nada..."
read CONFIRM
EOF
chmod +x /opt/kalan/scripts/kalan-menu-servicios-red.sh
ln -sf /opt/kalan/scripts/kalan-menu-servicios-red.sh /usr/local/bin/

#####ENDSCRIPT##### /opt/kalan/scripts/kalan-menu-servicios-red.sh

#####SCRIPT##### cambio-en-red.sh
cat << 'EOF' > /opt/kalan/scripts/cambio-en-red.sh
#!/bin/sh
IP_ACTUAL=$(/opt/kalan/scripts/get-ip-address.sh)
echo "$IP_ACTUAL" > /tmp/ip.actual
IP_ANTERIOR="127.0.0.1"

if [ ! "$IP_ACTUAL" == "" ]; then
	if [ -e /tmp/ip.ant ]; then
		IP_ANTERIOR="$(cat /tmp/ip.ant)"
		echo "ip anterior leida:$IP_ANTERIOR $1"
	fi
	echo "  IP ANTERIOR: $IP_ANTERIOR"
	echo "  IP ACTUAL  : $IP_ACTUAL"
	if [ ! "$IP_ACTUAL" == "$IP_ANTERIOR" ]; then
		echo "La direccion de red principal ha cambiado $1"
		#echo "Pulse enter para continuar"
		#read CONFIRM
	else
		echo "direccion de red sin cambios $1"
	fi
	echo "$IP_ACTUAL" > /tmp/ip.ant
	/opt/kalan/scripts/crear-banners.sh
else
	echo "Sin Direccion IP Actual $1"
fi
chmod 777 /tmp/ip.ant
chmod 777 /tmp/ip.actual
EOF
chmod +x /opt/kalan/scripts/cambio-en-red.sh
ln -sf /opt/kalan/scripts/cambio-en-red.sh /usr/local/bin/
#####ENDSCRIPT##### cambio-en-red.sh


#####SCRIPT##### seleccionar-red.sh
cat << 'EOF' > /opt/kalan/scripts/seleccionar-red.sh
#!/bin/bash
clear
source /opt/kalan/scripts/kalan-lib.sh
pruebaLib
if [ ! -e /etc/udev/rules.d/70-persistent-net.rules ];then
   	echo "detectando hardware..."

   /sbin/start_udev
   /sbin/service network restart;
   clear
fi
show_menu(){

	options=()
	array_eth=()
	array_mac=()
	 unset array_mac
	 unset array_eth
	TOTAL_INTERFASES=0
	file="/etc/udev/rules.d/70-persistent-net.rules"
	while read -r line; do
		[[ "$line" =~ ^#.*$ ]] && continue
		if [ ! "$line" == "" ]; then
			#echo "${line}"
			NAME=$(echo "$line" | grep -oP '(?<=NAME=").*?(?=")' )
			#echo "$NAME"
			MAC=$(echo "$line" | grep -oP '(?<=ATTR{address}==").*?(?=")' )
			#echo "$MAC"
			array_eth+=("$NAME")
			array_mac+=("$MAC")
			TOTAL_INTERFASES+=1
		fi
	done < "$file"

	NORMAL=`echo "\033[m"`
	MENU=`echo "\033[36m"` #Blue
	NUMBER=`echo "\033[33m"` #yellow
	FGRED=`echo "\033[41m"`
	RED_TEXT=`echo "\033[31m"`
	ENTER_LINE=`echo "\033[33m"`
	echo "Seleccione una interfase de red"
	echo -e "${MENU}----------------------------------------------------------------${NORMAL}"
	echo -e "${MENU}  ${NUMBER} 1)${NORMAL} ${array_eth[0]} MAC:${array_mac[0]} ${NORMAL}"
	echo -e "${MENU}  ${NUMBER} 2)${NORMAL} ${array_eth[1]} MAC:${array_mac[1]} ${NORMAL}"
	echo -e "${MENU}  ${NUMBER} 3)${NORMAL} ${array_eth[2]} MAC:${array_mac[2]} ${NORMAL}"
	echo -e "${MENU}  ${NUMBER} 4)${NORMAL} ${array_eth[3]} MAC:${array_mac[3]}${NORMAL}"
	echo -e "${MENU}  ${NUMBER} 5)${NORMAL} Salir ${NORMAL}"

	echo -e "${MENU}----------------------------------------------------------------${NORMAL}"
	echo -e "${ENTER_LINE}TECLEE UN NUMERO y -ENTER- o ${RED_TEXT}solo -ENTER- para salir. ${NORMAL}"
	read opt
}
function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No se paso mensaje"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

clear
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then
	        clear;
            exit;
    else

        case $opt in
        1) clear;
        	option_picked "Selecciono ${array_eth[0]} ";

        	reemplazarEnArch 'NAME="eth0"' 'NAME="${array_eth[0]}"' /etc/udev/rules.d/70-persistent-net.rules
       	    reemplazarEnArch 'NAME="${array_eth[0]}"' 'NAME="eth0"' /etc/udev/rules.d/70-persistent-net.rules
			yes | \cp -rf /opt/kalan/standard/ifcfg-eth0.standard /etc/sysconfig/network-scripts/ifcfg-eth0
			/sbin/start_udev
			/sbin/service network restart;
			clear;
            show_menu;
			/opt/kalan/scripts/cambio-en-red.sh

        ;;

        2) clear;
            option_picked "Option 2 Picked";
            #sudo mount /dev/sdi1 /mnt/usbDrive; #The 500 gig drive
            show_menu;
            ;;

        3) clear;
            option_picked "Option 3 Picked";
        #sudo service apache2 restart;
            show_menu;
            ;;

        4) clear;
            option_picked "Option 4 Picked";
        #ssh lmesser@ -p 2010;
            show_menu;
            ;;
        5)clear;
		exit;
		;;
        x)clear;
		exit;
        ;;
        0)clear;
		exit;
        ;;

        \n)clear;
		exit;
        ;;

        *)clear;
        option_picked "Seleccione una opcion que exista en el menu";
        show_menu;
        ;;
    	esac

fi
done
EOF
chmod +x /opt/kalan/scripts/seleccionar-red.sh
ln -sf /opt/kalan/scripts/seleccionar-red.sh /usr/local/bin/
#####ENDSCRIPT##### seleccionar-red.sh

#####SCRIPT##### info-del-sistema.sh
cat << 'EOF' > /opt/kalan/scripts/info-del-sistema.sh
#!/bin/bash
echo prueba
EOF
chmod +x /opt/kalan/scripts/info-del-sistema.sh
ln -sf /opt/kalan/scripts/info-del-sistema.sh /usr/local/bin/
#####ENDSCRIPT##### info-del-sistema.sh

#####SCRIPT##### kalan-actualizar.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-actualizar.sh
#!/bin/bash
  cd  /opt/kalan/scripts/
  rm -rf /opt/kalan/scripts/kalan-actualizacion-web

  URL_ACTUALIZACION=$(sed 'y/ ,/\n\n/;/^URL_ACTUALIZACION/P;D' </opt/kalan-data/conf/kalan.conf | awk -F= '{print $NF}')

  wget --no-check-certificate $URL_ACTUALIZACION
  cat kalan-actualizar.sh
  cat kalan-actualizacion-web
  chmod +x kalan-actualizacion-web
  /opt/kalan/scripts/kalan-actualizacion-web
EOF
chmod +x /opt/kalan/scripts/kalan-actualizar.sh
ln -sf /opt/kalan/scripts/kalan-actualizar.sh /usr/local/bin/

#####ENDSCRIPT##### kalan-actualizar.sh

#####SCRIPT##### configurar-red.sh
cat << 'EOF' > /opt/kalan/scripts/configurar-red.sh
#!/bin/bash
clear
sudo  /usr/bin/nmtui
clear
EOF
chmod +x /opt/kalan/scripts/configurar-red.sh
ln -sf /opt/kalan/scripts/configurar-red.sh /usr/local/bin/
#####SCRIPT##### configurar-red.sh

#####SCRIPT##### instalar-mongo.sh
cat << 'EOF' > /opt/kalan/scripts/instalar-mongo.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
cat << 'MONGOREPO' > /etc/yum.repos.d/mongodb-org-3.2.repo
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
MONGOREPO
cd /root/kickstart_build/isolinux/Packages/

if [ ! -e /root/kickstart_build/isolinux/Packages/mongodb-org-3.2.0-1.el7.x86_64.rpm ];then
yumdownloader mongodb-org-3.2.0-1.el7.x86_64
yumdownloader mongodb-org-server-3.2.0-1.el7.x86_64
yumdownloader mongodb-org-mongos-3.2.0-1.el7.x86_64
yumdownloader mongodb-org-shell-3.2.0-1.el7.x86_64
yumdownloader mongodb-org-tools-3.2.0-1.el7.x86_64
fi
yum -y localinstall mongodb-org-3.2.0-1.el7.x86_64.rpm mongodb-org-server-3.2.0-1.el7.x86_64.rpm mongodb-org-mongos-3.2.0-1.el7.x86_64.rpm mongodb-org-shell-3.2.0-1.el7.x86_64.rpm mongodb-org-tools-3.2.0-1.el7.x86_64.rpm

cat << 'DISABLEHUGE' > /etc/init.d/disable-transparent-hugepages
#!/bin/sh
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo "never" > ${thp_path}/enabled
    echo "never" > ${thp_path}/defrag

    unset thp_path
    ;;
esac
DISABLEHUGE
sudo chmod 755 /etc/init.d/disable-transparent-hugepages
sudo chkconfig --add disable-transparent-hugepages
sudo mkdir /etc/tuned/no-thp
cat << 'DISABLETUNED' > /etc/tuned/no-thp/tuned.conf
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
DISABLETUNED
sudo tuned-adm profile no-thp

ulimit -f unlimited
ulimit -t unlimited
ulimit -v unlimited
ulimit -n 64000
ulimit -m unlimited
ulimit -u 64000

echo "Modificando firewall para mongodb. Espera por favor..."
semanage port -a -t mongod_port_t -p tcp 27017
sudo chkconfig mongod on
systemctl start mongod

cd /opt/kalan/sw
if [ ! -e /opt/kalan/sw/dataset.json ];then
   wget https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/dataset.json
fi
cp dataset.json primer-dataset.json
mongoimport --db test --collection restaurants --drop --file primer-dataset.json
systemctl start mongod


#mongod --port 27017 --dbpath /data/db1

EOF

chmod +x /opt/kalan/scripts/instalar-mongo.sh
ln -sf /opt/kalan/scripts/instalar-mongo.sh /usr/local/bin/

#####SCRIPT##### instalar-mongo.sh

#####SCRIPT##### configurar-mongo.sh
cat << 'EOF' > /opt/kalan/scripts/configurar-mongo.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
kalanmongopw=$1
#kalanmongopw=$(dialog --title "Clave de usuario kalanmongo" --no-cancel --insecure --stdout --clear --passwordbox "teclee nueva clave" 10 40 2)
mongo admin --eval "printjson(db.getCollectionNames())"

#mongo admin --eval "db.dropUser('servidor')"
mongo admin --eval "db.createUser({user: 'servidor',pwd: '$kalanmongopw',roles: [ { role: 'userAdminAnyDatabase', db: 'admin' }]})"
#mongo kalan --eval "db.dropUser('kalanmongo')"
KALANPG_MD5=$(kalan-var "KALANPG_MD5")
mongo admin --eval "db.createUser({user: 'kalanmongo',pwd: '$KALANPG_MD5',roles: [ { role: 'userAdminAnyDatabase', db: 'admin' }]})"

if [ ! -e /etc/mongod.original ];then
   cp /etc/mongod.conf /etc/mongod.original
   #echo "auth = true" >> /etc/mongod.conf
fi
cp -rf /etc/mongod.original /etc/mongod.conf

EOF

chmod +x /opt/kalan/scripts/configurar-mongo.sh
ln -sf /opt/kalan/scripts/configurar-mongo.sh /usr/local/bin/

#####ENDSCRIPT##### configurar-mongo.sh

#####SCRIPT##### instalar-postgres.sh
cat << 'EOF' > /opt/kalan/scripts/instalar-postgres.sh
#!/bin/bash

sudo postgresql-setup initdb
sudo systemctl enable postgresql.service
/opt/kalan/scripts/configurar-postgres.sh

EOF

chmod +x /opt/kalan/scripts/instalar-postgres.sh
ln -sf /opt/kalan/scripts/instalar-postgres.sh /usr/local/bin/

#####SCRIPT##### instalar-postgres.sh

#####SCRIPT##### configurar-postgres.sh
cat << 'EOF' > /opt/kalan/scripts/configurar-postgres.sh
#!/bin/bash

if [ ! -e /var/lib/pgsql/data/pg_hba.original ];then
 cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.original
fi
cat << 'ARCHIVOEOF' >/var/lib/pgsql/data/pg_hba.conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             servidor        127.0.0.1/32            trust
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            ident
#host    replication     postgres        ::1/128                 ident


ARCHIVOEOF


#cat /var/lib/pgsql/data/pg_hba.conf
systemctl restart postgresql.service

sudo -i -u postgres psql <<EOFSQL
\x
CREATE ROLE kalanpg LOGIN ENCRYPTED PASSWORD 'md57d66509b289d5d5d6330435ec2134f3a' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';
CREATE DATABASE kalanpg WITH ENCODING='UTF8' CONNECTION LIMIT=-1;
ALTER DATABASE kalanpg OWNER TO kalanpg;
GRANT ALL ON DATABASE kalanpg TO kalanpg;
CREATE ROLE servidor LOGIN SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';
CREATE DATABASE servidor WITH ENCODING='UTF8' CONNECTION LIMIT=-1;
EOFSQL

EOF

chmod +x /opt/kalan/scripts/configurar-postgres.sh
ln -sf /opt/kalan/scripts/configurar-postgres.sh /usr/local/bin/

#####SCRIPT##### configurar-postgres.sh





#####SCRIPT##### instalar-paquetes.sh
cat << 'EOF' > /opt/kalan/scripts/instalar-paquetes.sh
#!/bin/bash
# Verify packages are up to date
parametro="$1"
# Install required packages

cat << 'EOFKALAN' >/opt/kalan/sw/kalan-core.fil
deltarpm python-deltarpm yum-utils unzip nano net-tools wget git ntp dialog dvd+rw-tools createrepo sudo
gcc make zlib-devel bzip2-devel  ncurses-devel libxml2-devel libxml2 libxml2-python libxslt-devel  pcre-devel curl-devel
firewalld policycoreutils-python nmap openscap openscap-scanner scap-security-guide openssl openssl-devel
sqlite sqlite-devel mysql-devel unixODBC-devel postgresql-devel
postgresql postgresql-server postgresql-contrib postgresql-libs postgresql-plperl postgresql-plpython python-psycopg
httpd httpd-devel mod_ssl
graphviz graphviz-devel ImageMagick
xz-libs
vim-enhanced*
genisoimage  libusal pykickstart
chrony
kernel-devel
EOFKALAN

echo "------------------------- instalar-paquetes----------------------------"
echo "parametro: $parametro"
if [ "$parametro" != "postinstall" ]; then
   yum -y update
   yum -y upgrade
   yum -y install $(cat /opt/kalan/sw/kalan-core.fil)
fi
EOF
chmod 770 /opt/kalan/scripts/instalar-paquetes.sh
ln -sf /opt/kalan/scripts/instalar-paquetes.sh /usr/local/bin/

#####ENDSCRIPT##### instalar-paquetes.sh

#####SCRIPT##### instalar-python.sh
cat << 'EOF' > /opt/kalan/scripts/instalar-python.sh
#!/bin/bash
echo "Siguente: Instalar Python"
#read CONFIRM
parametro=$1

# Verify we have at least Python 2.5
typeset -i version_major
typeset -i version_minor

version=`rpm --qf %{Version} -q python`
version_major=`echo ${version} | awk '{split($0, parts, "."); print parts[1]}'`
version_minor=`echo ${version} | awk '{split($0, parts, "."); print parts[2]}'`

#if [ ! ${version_major} -ge 2 -o ! ${version_minor} -ge 7 ]; #then
#fi
    # Check for earlier Python 2.7 install
    if [ -e /usr/local/bin/python2.7 ]; then
        python_installed='True'
        # Is Python already installed?
        RETV=`/usr/local/bin/python2.7 -V > /dev/null 2>&1; echo $?`
                echo "----------------------------- $RETV ---------------------------------"
        if [ ${RETV} -eq 0 ]; then
            python_installed='True'
        fi
    fi

    # Install Python 2.7 if it doesn't exist already
    if [ ! "${python_installed}" == "True" ]; then
        # Install requirements for the Python build
        # Download and install
		cd /opt/kalan/sw/
		if [ ! -e /opt/kalan/sw/Python-2.7.10.tar.xz ];then
          wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tar.xz
		fi

		sudo tar xf Python-2.7.10.tar.xz
        cd Python-2.7.10
        ./configure --prefix=/usr/local
        make && make altinstall

        cd /opt/kalan/sw
    fi


    /sbin/ldconfig



#scl enable python2.7 bash
cd /opt/kalan/sw


if [ ! -e /opt/kalan/sw/setuptools-19.1.1.tar.gz ];then
 wget https://pypi.python.org/packages/source/s/setuptools/setuptools-19.1.1.tar.gz#md5=792297b8918afa9faf826cb5ec4a447a
fi

tar xzf setuptools-19.1.1.tar.gz
cd /opt/kalan/sw/setuptools-19.1.1
/usr/local/bin/python2.7 setup.py install


cd /opt/kalan/sw

if [ ! -e /opt/kalan/sw/pip-7.1.2.tar.gz ];then
	wget https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz#md5=3823d2343d9f3aaab21cf9c917710196
fi

tar xzf pip-7.1.2.tar.gz
cd /opt/kalan/sw/pip-7.1.2
/usr/local/bin/python2.7 setup.py install

if [ ! -e /opt/kalan/sw/google-api-python-client-1.4.2.tar.gz ];then
	wget https://pypi.python.org/packages/source/g/google-api-python-client/google-api-python-client-1.4.2.tar.gz#md5=7033985a645e39d3ccf1b2971ab7b6b8
fi

tar xzf google-api-python-client-1.4.2.tar.gz
cd /opt/kalan/sw/google-api-python-client-1.4.2
/usr/local/bin/python2.7 setup.py install

if [ ! -d /opt/kalan/sw/pip ];then
	mkdir -p /opt/kalan/sw/pip
fi

if [ ! -e /opt/kalan/sw/kalan-py-req.txt ];then
cat << ARCHREQ > /opt/kalan/sw/kalan-py-req.txt
pyasn1==0.1.7
argparse==1.4.0
beautifulsoup4==4.4.1
google-api-python-client==1.4.2
graphviz==0.4.8
lxml==3.5.0
mechanize==0.2.5
meld3==1.0.2
oauth2client==1.5.2
oauthlib==1.0.3
pbr==1.8.1
psycopg2==2.6.1
pygraphviz==1.3.1
pymongo==3.2
requests==2.9.1
requests_oauthlib==0.6.0
simplejson==3.8.1
six==1.10.0
stevedore==1.10.0
supervisor==3.2.0
tweepy==3.5.0
virtualenv==13.1.2
virtualenv-clone==0.2.6
virtualenvwrapper==4.7.1
web2py_utils
httplib2
docker-py

ARCHREQ
fi

ls /opt/kalan/sw/pip > /opt/kalan/sw/pips
cd /opt/kalan/sw/pip

if [ "$parametro" != "postinstall" ];then
	echo " "
	echo "Descargando paquetes si no estan localmente"
	echo "------------------------------------------------------------------------------"
	/usr/local/bin/pip2.7 install --download /opt/kalan/sw/pip -r /opt/kalan/sw/kalan-py-req.txt
fi

echo "Instalando paquetes locales"
echo "------------------------------------------------------------------------------"
/usr/local/bin/pip2.7 install -r /opt/kalan/sw/kalan-py-req.txt --no-index --find-links file:///opt/kalan/sw/pip

echo " "
echo "______________________________________________________________________________"
echo "FIN Instalacion Python. Verifique si no hay Errores:"
echo "presione ENTER para continuar...[ctrl+C para abortar]"
echo "Siguiente: Instalar "
#read CONFIRM
EOF
chmod 770 /opt/kalan/scripts/instalar-python.sh
ln -sf /opt/kalan/scripts/instalar-python.sh /usr/local/bin/
#####ENDSCRIPT##### instalar-python.sh

#####SCRIPT##### kalan-eliminar-aplicacion.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-eliminar-aplicacion.sh
if [ $# -eq 0 ];then
  echo "No se paso nombre de aplicacion"
else
	if [ -d /opt/web-apps/web2py/applications/$1 ];then
		read -r -p         "AVISO: Esta Seguro de elimnar la aplicacion $1 ? [s/N] " response
		case $response in
		[sS][iI]|[sS])
				NOMBRE_BASE="kalan_$1"
				systemctl stop web2pyd
				rm -rf /opt/web-apps/web2py/applications/$1
				echo "Solo se elimino aplicacion. Elimine manualmente la base de datos $NOMBRE_BASE"
				echo "Pulse ENTER para reiniciar el servicio con los cambios"
				read CONFIRM
				systemctl start web2pyd
		;;
		*)  echo "No se elimino nada";
			;;
		esac
    else
	    echo "AVISO: No se configura nada. NO existe aplicacion $1"
	fi

fi
EOF
chmod 770 /opt/kalan/scripts/kalan-eliminar-aplicacion.sh
ln -sf /opt/kalan/scripts/kalan-eliminar-aplicacion.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-eliminar-aplicacion.sh

#####SCRIPT##### kalan-configurar-aplicacion.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-configurar-aplicacion.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh

echo "Configurando aplicacion: $1"
if [ -d /opt/web-apps/web2py/applications/$1 ];then
   sudo chown -R kalan:kalan /opt/web-apps/web2py/applications/$1

   NOMBRE_BASE="kalan_$1"

sudo -i -u postgres psql <<EOFSQL
\x
CREATE DATABASE $NOMBRE_BASE WITH ENCODING='UTF8' CONNECTION LIMIT=-1;
ALTER DATABASE $NOMBRE_BASE OWNER TO kalanpg;
GRANT ALL ON DATABASE $NOMBRE_BASE TO kalanpg;
EOFSQL
   KALANPG_MD5=$(kalan-var "KALANPG_MD5")
   ARCONFIG="/opt/web-apps/web2py/applications/$1/private/appconfig.ini"
   ARMODEL="/opt/web-apps/web2py/applications/$1/models/0.py"
   KALAN_INI="/opt/web-apps/web2py/applications/$1/models/kalan_ini.py"
   DB_PY="/opt/web-apps/web2py/applications/$1/models/db.py"
   #cp /opt/kalan/standard/appconfig.ini.standard
   echo "REEMPLAZANDO EN $ARCONFIG"
   reemplazarEnArch "sqlite:" "postgres:" $ARCONFIG
   reemplazarEnArch "storage.sqlite" "kalanpg:$KALANPG_MD5@localhost/$NOMBRE_BASE" $ARCONFIG
   reemplazarEnArch "sqlite:" "postgres:" $ARMODEL
   reemplazarEnArch "storage.sqlite" "kalanpg:$KALANPG_MD5@localhost/$NOMBRE_BASE" $ARMODEL
   reemplazarEnArch "username=False" "username=True" $DB_PY
   reemplazarEnArch "signature=False" "signature=True" $DB_PY

cat << 'EOF_PY' > $KALAN_INI
########################################

if not db().select(db.auth_user.ALL).first():
    db.auth_user.username.unique=True
    db.auth_user.insert(
        username = 'admin',
        password = db.auth_user.password.validate('admin')[0],
        email = 'info@kalan.com',
        first_name = 'admin',
        last_name = 'Administrator',
    )
    auth.add_group('admin', 'sysadmin')
    auth.add_group('kalan', 'kalan')
    auth.add_group('usuarios', 'usuarios')
    auth.add_membership(auth.id_group('admin'), 1)

EOF_PY

   sudo chown -R kalan:kalan /opt/web-apps/web2py/applications/$1


else
   echo "AVISO: No se configura nada. NO existe aplicacion $1"

fi
echo "pulse enter para continuar"
#read CONFIRM

EOF
chmod 770 /opt/kalan/scripts/kalan-configurar-aplicacion.sh
ln -sf /opt/kalan/scripts/kalan-configurar-aplicacion.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-configurar-aplicacion.sh

#####SCRIPT##### kalan-clonar-aplicacion.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-clonar-aplicacion.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh

echo "copiando $1 -> $2"
if [ -d /opt/web-apps/web2py/applications/$2 ];then
   echo "AVISO: No se copia nada. Ya existe aplicacion $2"
 else
   echo "Copiando carpeta de aplicacion a $2"
   cp -rf /opt/web-apps/web2py/applications/$1 /opt/web-apps/web2py/applications/$2
   sudo chown -R kalan:kalan /opt/web-apps/web2py/applications/$2
fi
/opt/kalan/scripts/kalan-configurar-aplicacion.sh $2

EOF
chmod 770 /opt/kalan/scripts/kalan-clonar-aplicacion.sh
ln -sf /opt/kalan/scripts/kalan-clonar-aplicacion.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-clonar-aplicacion.sh

#####SCRIPT##### kalan-ac.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-ac.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
echo "Abriendo $1"
if [ -d /opt/web-apps/web2py/applications/$1 ];then
   python2.7 /opt/web-apps/web2py/web2py.py -S $1 -M
else
   echo "AVISO: No existe aplicacion $2"
   echo "pulse enter para continuar"
   read CONFIRM
fi

EOF
chmod 770 /opt/kalan/scripts/kalan-ac.sh
ln -sf /opt/kalan/scripts/kalan-ac.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-ac.sh

#####SCRIPT##### instalar-web2py.sh
cat << 'EOF' > /opt/kalan/scripts/instalar-web2py.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
KALAN_IP=$(/opt/kalan/scripts/get-ip-address.sh)
KALAN_WEB2PY_PORT=8888
KALAN_HOSTNAME=$HOSTNAME



# Download
if [ ! -e /opt/kalan/sw/web2py_src.zip ]; then
    cd /opt/kalan/sw/
	wget web2py.com/examples/static/2.12.1/web2py_src.zip
fi
yes | \cp -rf /opt/kalan/sw/web2py_src.zip /opt/web-apps/web2py_src.zip

cd /opt/web-apps
unzip web2py_src.zip

chown -R kalan:kalan web2py
cd /opt


# Setup the proper context on the writable application directories
cd /opt/web-apps/web2py/applications
for app in `ls`
do
    for dir in databases cache errors sessions private uploads
    do
        mkdir ${app}/${dir}
        chown kalan:kalan ${app}/${dir}
        #chcon -R -t tmp_t ${app}/${dir}
    done
done
yes | \cp -rf /opt/kalan/standard/web2pyd.systemctl.standard /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_IP##" "$KALAN_IP" /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_WEB2PY_PORT##" "$KALAN_WEB2PY_PORT" /etc/systemd/system/web2pyd.service


chmod +x /etc/systemd/system/web2pyd.service
systemctl daemon-reload

systemctl enable  web2pyd.service
systemctl daemon-reload
EOF
chmod 770 /opt/kalan/scripts/instalar-web2py.sh
ln -sf /opt/kalan/scripts/instalar-web2py.sh /usr/local/bin/
#####ENDSCRIPT##### instalar-web2py.sh

#####SCRIPT##### ZZZ-kalan-httpd.standard
cat << 'EOF' > /opt/kalan/standard/ZZZ-kalan-httpd.standard

ServerName ##KALAN_HOSTNAME##:80
ServerTokens Prod
SecServerSignature Off
Include modsecurity-crs/modsecurity_crs_10_config.conf
Include modsecurity-crs/base_rules/*.conf

#falsos positivos de modsecure
#SecRuleRemoveByID "981173 981203 960017"

##
## SSL Virtual Host Context
##


<VirtualHost *:443>
     ServerName ##KALAN_HOSTNAME##
     SSLEngine On
     SSLCertificateFile /etc/httpd/ssl/self_signed.cert
     SSLCertificateKeyFile /etc/httpd/ssl/self_signed.key
     #filtrar protocolos vulnerables
     SSLProtocol ALL -SSLv2 -SSLv3
     SSLHonorCipherOrder On
	 #incluir los algoritmos de cifrado recomendables
     SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5
     #SSLCompression Off
     # para pruebas: Vulnerable SSLCipherSuite DEFAULT:!EXP:!SSLv2:!DES:!IDEA:!SEED:+3DES
     SSLProxyEngine on

	  <Location "/">
		 Order deny,allow
		 Allow from all
		 ProxyPass ##KALAN_DESTINO_PROXY##/
		 ProxyPassReverse ##KALAN_DESTINO_PROXY##/
     </Location>

     #LogFormat "%h %l %u %t '%r' %>s %b" common
     ErrorLog /var/log/httpd/ssl_error_log
     TransferLog /var/log/httpd/ssl_access_log
</VirtualHost>

##para direccionar todo a https

<VirtualHost *:80>

      ServerName ##KALAN_HOSTNAME##
	  <LocationMatch "^/admin">
          SSLRequireSSL
      </LocationMatch>
      ### appadmin requires SSL
      <LocationMatch "^/welcome/appadmin/.*">
         SSLRequireSSL
      </LocationMatch>
      <LocationMatch "^/kalan/appadmin/.*">
         SSLRequireSSL
      </LocationMatch>
      <LocationMatch "^/SG/appadmin/.*">
         SSLRequireSSL
      </LocationMatch>
      <LocationMatch "^/kalan/appadmin/.*">
         SSLRequireSSL
      </LocationMatch>
	  <Location "/">
		 Order deny,allow
		 Allow from all
		 ProxyPass ##KALAN_DESTINO_PROXY##/
		 ProxyPassReverse ##KALAN_DESTINO_PROXY##/
     </Location>

       #RewriteEngine On
       #RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]

</VirtualHost>

EOF
#####ENDSCRIPT##### ZZZ-kalan-httpd.standard

#####SCRIPT##### asignar-host-httpd.sh
cat << 'EOF' > /opt/kalan/scripts/asignar-host-httpd.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
pruebaLib

yes | \cp -rf /opt/kalan/standard/ZZZ-kalan-httpd.standard /etc/httpd/conf.d/ZZZ-kalan-httpd.conf
reemplazarEnArch "##KALAN_HOSTNAME##" "$1" /etc/httpd/conf.d/ZZZ-kalan-httpd.conf
reemplazarEnArch "##KALAN_IP##" "$2" /etc/httpd/conf.d/ZZZ-kalan-httpd.conf
reemplazarEnArch "##KALAN_WEB2PY_PORT##" "8888" /etc/httpd/conf.d/ZZZ-kalan-httpd.conf
reemplazarEnArch "##KALAN_DESTINO_PROXY##" "$3" /etc/httpd/conf.d/ZZZ-kalan-httpd.conf

EOF
chmod +x /opt/kalan/scripts/asignar-host-httpd.sh
ln -sf /opt/kalan/scripts/asignar-host-httpd.sh /usr/local/bin/
#####ENDSCRIPT##### asignar-host-httpd.sh

#####SCRIPT##### kalan-estado.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-estado.sh
sudo systemctl status $1
EOF
chmod +x /opt/kalan/scripts/kalan-estado.sh
ln -sf /opt/kalan/scripts/kalan-estado.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-estado.sh

#####SCRIPT##### kalan-iniciar.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-iniciar.sh
#!/bin/bash
sudo systemctl start $1
EOF
chmod +x /opt/kalan/scripts/kalan-iniciar.sh
ln -sf /opt/kalan/scripts/kalan-iniciar.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-iniciar.sh

#####SCRIPT##### kalan-detener.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-detener.sh
#!/bin/bash
sudo systemctl stop $1
EOF
chmod +x /opt/kalan/scripts/kalan-detener.sh
ln -sf /opt/kalan/scripts/kalan-detener.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-detener.sh

#####SCRIPT##### kalan-activar.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-activar.sh
#!/bin/bash
sudo systemctl enable $1
EOF
chmod +x /opt/kalan/scripts/kalan-activar.sh
ln -sf /opt/kalan/scripts/kalan-activar.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-activar.sh

#####SCRIPT##### kalan-desactivar.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-desactivar.sh
#!/bin/bash
sudo systemctl disable $1
EOF
chmod +x /opt/kalan/scripts/kalan-desactivar.sh
ln -sf /opt/kalan/scripts/kalan-desactivar.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-desactivar.sh


#####SCRIPT##### web2pyd.systemctl.standard
#construir daemon con intermedio /etc/systemd/system/web2pyd.service
cat << 'EOF' > /opt/kalan/standard/web2pyd.systemctl.standard
[Unit]
Description=Servidor web2pyd
[Service]

User=kalan
ExecStart=/usr/local/bin/python2.7 /opt/web-apps/web2py/web2py.py --nogui -a "<recycle>" -i 127.0.0.1 -p 8888
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOF
#####ENDSCRIPT##### web2pyd.systemctl.standard

#####SCRIPT##### instalar-modsecurity.sh

cat << 'EOF' > /opt/kalan/scripts/instalar-modsecurity.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
pruebaLib

echo "Siguente: Instalar ModSecurity"

cd /opt/kalan/sw
if [ ! -e /opt/kalan/sw/modsecurity-2.9.0.tar.gz ];then
    wget https://www.modsecurity.org/tarball/2.9.0/modsecurity-2.9.0.tar.gz
fi
tar xzf modsecurity-2.9.0.tar.gz
cd modsecurity-2.9.0
./configure
make install
cp modsecurity.conf-recommended /etc/httpd/conf.d/modsecurity.conf
cp modsecurity.conf-recommended /etc/httpd/conf.d/modsecurity.original

cp unicode.mapping /etc/httpd/conf.d/

if [ ! -d /opt/kalan/sw/owasp-modsecurity-crs ];then
    cd /opt/kalan/sw/
	git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git
fi
cd /etc/httpd
cp -rf /opt/kalan/sw/owasp-modsecurity-crs /etc/httpd/modsecurity-crs
cd /etc/httpd/modsecurity-crs
cp modsecurity_crs_10_setup.conf.example modsecurity_crs_10_config.conf
> /etc/httpd/modsecurity-crs/base_rules/modsecurity_crs_99_excepciones.conf
echo "#excepciones modsecurity v1.0" >> /etc/httpd/modsecurity-crs/base_rules/modsecurity_crs_99_excepciones.conf
echo 'SecRuleRemoveByID 981173 "pass"' >> /etc/httpd/modsecurity-crs/base_rules/modsecurity_crs_99_excepciones.conf
echo 'SecRuleRemoveByID 981203 "pass"' >> /etc/httpd/modsecurity-crs/base_rules/modsecurity_crs_99_excepciones.conf
echo 'SecRuleRemoveByID 960017 "pass"' >> /etc/httpd/modsecurity-crs/base_rules/modsecurity_crs_99_excepciones.conf
if [ ! -e /opt/kalan/standard/modsecurity.standard ]; then
     echo "Respaldando /opt/kalan/standard/modsecurity.standard"
    cp /etc/httpd/conf.d/modsecurity.conf /opt/kalan/standard/modsecurity.standard

fi
echo "LoadModule security2_module modules/mod_security2.so" >/etc/httpd/conf.d/modsecurity.conf
echo "#LoadModule unique_id_module modules/mod_unique_id.so" >>/etc/httpd/conf.d/modsecurity.conf
cat /opt/kalan/standard/modsecurity.standard >>/etc/httpd/conf.d/modsecurity.conf
reemplazarEnArch "SecStatusEngine On" "#SecStatusEngine Off" /opt/kalan/standard/modsecurity.standard
reemplazarEnArch "SecStatusEngine On" "#SecStatusEngine Off" /etc/httpd/conf.d/modsecurity.conf

EOF

chmod +x /opt/kalan/scripts/instalar-modsecurity.sh
ln -sf /opt/kalan/scripts/instalar-modsecurity.sh  /usr/local/bin/
#####ENDSCRIPT##### Fin instalar-modsecurity.sh

#####SCRIPT##### desactivar-mlogc.sh
cat <<'EOF'>/opt/kalan/scripts/desactivar-mlogc.sh
#!/bin/bash
mv -f /etc/httpd/conf.d/modsecurity_99_consola_mlogc.conf /etc/httpd/conf.d/modsecurity_99_consola_mlogc.disabled
EOF
chmod +x /opt/kalan/scripts/desactivar-mlogc.sh
ln -sf /opt/kalan/scripts/desactivar-mlogc.sh  /usr/local/bin/
#####ENDSCRIPT##### Fin activar-mlogc
#####SCRIPT##### activar-mlogc.sh
cat <<'EOF'>/opt/kalan/scripts/activar-mlogc.sh
mv -f /etc/httpd/conf.d/modsecurity_99_consola_mlogc.disabled /etc/httpd/conf.d/modsecurity_99_consola_mlogc.conf
EOF
chmod +x /opt/kalan/scripts/activar-mlogc.sh
ln -sf /opt/kalan/scripts/activar-mlogc.sh  /usr/local/bin/
#####ENDSCRIPT##### Fin activar-mlogc.sh


#####SCRIPT##### instalar-mlogc.sh
cat <<'EOF'>/opt/kalan/scripts/instalar-mlogc.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
pruebaLib
#####SCRIPT##### mlogc2.conf
cat <<'EOFMLOGC2'>/etc/mlogc-kalan.conf
#--------------------------------- inicio mlogc.conf ---------------------
##########################################################################
# Required configuration
#   At a minimum, the items in this section will need to be adjusted to
#   fit your environment.  The remaining options are optional.
##########################################################################

# Points to the root of the installation. All relative
# paths will be resolved with the help of this path.
CollectorRoot       "/var/log/mlogc"

# ModSecurity Console receiving URI. You can change the host
# and the port parts but leave everything else as is.
ConsoleURI          "http://127.0.0.1:8888/kalan/mlogc"

# Sensor credentials
SensorUsername      "local"
SensorPassword      "modsec"

# Base directory where the audit logs are stored.  This can be specified
# as a path relative to the CollectorRoot, or a full path.
LogStorageDir       "data"

# Transaction log will contain the information on all log collector
# activities that happen between checkpoints. The transaction log
# is used to recover data in case of a crash (or if Apache kills
# the process).
TransactionLog      "mlogc-transaction.log"

# The file where the pending audit log entry data is kept. This file
# is updated on every checkpoint.
QueuePath           "mlogc-queue.log"

# The location of the error log.
ErrorLog            "mlogc-error.log"

# The location of the lock file.
LockFile            "mlogc.lck"

# Keep audit log entries after sending? (0=false 1=true)
# NOTE: This is required to be set in SecAuditLog mlogc config if you
# are going to use a secondary console via SecAuditLog2.
KeepEntries         0

##########################################################################
# Optional configuration
##########################################################################
# The error log level controls how much detail there
# will be in the error log. The levels are as follows:
#   0 - NONE
#   1 - ERROR
#   2 - WARNING
#   3 - NOTICE
#   4 - DEBUG
#   5 - DEBUG2
#
ErrorLogLevel       3

# How many concurrent connections to the server
# are we allowed to open at the same time? Log collector uses
# multiple connections in order to speed up audit log transfer.
# This is especially needed when the communication takes place
# over a slow link (e.g. not over a LAN).
MaxConnections      10

# How many requests a worker will process before recycling itself.
# This is to help prevent problems due to any memory leaks that may
# exists.  If this is set to 0, then no maximum is imposed. The default
# is 1000 requests per worker (the number of workers is controlled by the
# MaxConnections limit).
MaxWorkerRequests   1000

# The time each connection will sit idle before being reused,
# in milliseconds. Increase if you don't want ModSecurity Console
# to be hit with too many log collector requests.
TransactionDelay    50

# The time to wait before initialization on startup in milliseconds.
# Increase if mlogc is starting faster then termination when the
# sensor is reloaded.
StartupDelay        5000

# How often is the pending audit log entry data going to be written
# to a file. The default is 15 seconds.
CheckpointInterval  15

# If the server fails all threads will back down until the
# problem is sorted. The management thread will periodically
# launch a thread to test the server. The default is to test
# once in 60 seconds.
ServerErrorTimeout  60

# The following two parameters are not used yet, but
# reserved for future expansion.
# KeepAlive         150
# KeepAliveTimeout  300

#  To ignore the SSL checks, set InsecureNoCheckCert
#
InsecureNoCheckCert 1
#--------------------------------- fin mlogc.conf -----------------------
EOFMLOGC2
#####ENDSCRIPT##### mlogc.conf


#####SCRIPT##### /modsecurity_99_consola_mlogc.conf
cat <<'EOFAGREGADOS'>/etc/httpd/conf.d/modsecurity_99_consola_mlogc.conf
###Configure the ModSecurity sensor to use mlogc
SecAuditLogDirMode 1733
SecAuditLogFileMode 0550

# Use ReleventOnly auditing
SecAuditEngine RelevantOnly
# Must use concurrent logging
SecAuditLogType Concurrent
# Send all audit log parts
SecAuditLogParts ABIDEFGHZ
# Use the same /CollectorRoot/LogStorageDir as in mlogc.conf
SecAuditLogStorageDir /var/log/mlogc/data
# Pipe audit log to mlogc with your configuration
SecAuditLog "| /usr/local/modsecurity/bin/mlogc /etc/mlogc-kalan.conf"
SecAuditLog2 /var/log/modsec_audit.log
EOFAGREGADOS
#####ENDSCRIPT##### /modsecurity_99_consola_mlogc.conf

cp -rf /usr/local/modsecurity/bin/mlogc-batch-load.pl /usr/local/bin/
cp -rf /usr/local/modsecurity/bin/mlogc /usr/local/bin/
cp -rf /usr/local/modsecurity/bin/rules-updater.pl /usr/local/bin/

#### desactivar a solo deteccion
#reemplazarEnArch "SecRuleEngine On" "SecRuleEngine DetectionOnly" /etc/httpd/conf.d/modsecurity.conf
#reemplazarEnArch "SecRuleEngine On" "SecRuleEngine DetectionOnly" /opt/kalan/standard/modsecurity.standard


rm -rf /var/log/mlogc/

mkdir /var/log/mlogc
chgrp -R apache /var/log/mlogc
chmod g+s /var/log/mlogc/
chcon -Rv --type=httpd_sys_content_t /var/log/mlogc/
chcon -Rv -t tmp_t /var/log/mlogc/

mkdir /var/log/mlogc/data
chgrp -R apache /var/log/mlogc/data
chmod -R 777 /var/log/mlogc/data/
chmod g+s /var/log/mlogc/data/
chcon -Rv --type=httpd_sys_content_t /var/log/mlogc/data/
chcon -Rv -t tmp_t /var/log/mlogc/data/

if [ ! -e /etc/sysconfig/httpd.original ];then
    cp /etc/sysconfig/httpd /etc/sysconfig/httpd.original
	echo "umask 002" >> /etc/sysconfig/httpd
fi
/opt/kalan/scripts/desactivar-mlogc.sh

EOF

chmod +x /opt/kalan/scripts/instalar-mlogc.sh
ln -sf /opt/kalan/scripts/instalar-mlogc.sh /usr/local/bin/
#####ENDSCRIPT##### instalar-mlogc.sh




#####SCRIPT##### crear-banners.sh
cat << 'EOF' > /opt/kalan/scripts/crear-banners.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
echo " " > /etc/issue
echo " " > /opt/kalan/standard/issue-standard

echo "         SERVIDOR KALAN $KALAN_VERSION                         " >> /opt/kalan/standard/issue-standard
echo "______________________________________________________________________________" >> /opt/kalan/standard/issue-standard
echo "                                                               " >> /opt/kalan/standard/issue-standard
echo "         Requiere de un usuario y clave de acceso para ingresar" >> /opt/kalan/standard/issue-standard
echo "         a este equipo.Si no cuenta con uno salga de inmediato." >> /opt/kalan/standard/issue-standard
echo "         Todas las conexiones son registradas y monitoreadas.  " >> /opt/kalan/standard/issue-standard
echo "______________________________________________________________________________" >> /opt/kalan/standard/issue-standard
echo "                                                               " >> /opt/kalan/standard/issue-standard
cp /opt/kalan/standard/issue-standard /etc/issue.net
cp /opt/kalan/standard/issue-standard /etc/issue
KALAN_IPACTUAL=$(/opt/kalan/scripts/get-ip-address.sh)
echo "         $KALAN_IPACTUAL" >> /etc/issue
echo "                                                               " >> /etc/issue
cat /tmp/kalan-modo >> /etc/issue
echo "                                                               " >> /etc/issue
echo "$KALAN_IPACTUAL"
EOF
chmod +x /opt/kalan/scripts/crear-banners.sh
ln -sf /opt/kalan/scripts/crear-banners.sh /usr/local/bin/
#####ENDSCRIPT##### crear-banners.sh


#####SCRIPT##### kalan-modo-mantenimiento.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-modo-mantenimiento.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
pruebaLib
clear
sudo systemctl stop httpd
sudo systemctl stop web2pyd
echo "Espere un momento. cambiando a MODO mantenimiento..."
sudo firewall-cmd --zone=public --permanent --add-service=ssh

sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8888/tcp
firewall-cmd --reload

firewall-cmd --get-default-zone

semanage port -a -t ssh_port_t -p tcp 22
yes | \cp -rf /opt/kalan/standard/sshd_config.standard /etc/ssh/sshd_config
reemplazarEnArch "Port 2222" "Port 22" /etc/ssh/sshd_config
reemplazarEnArch "#Port 22" "Port 22" /etc/ssh/sshd_config
reemplazarEnArch "#Protocol 2" "Protocol 2" /etc/ssh/sshd_config
reemplazarEnArch "#Banner none" "Banner /etc/issue.net" /etc/ssh/sshd_config
#### desactivar a solo deteccion
reemplazarEnArch "SecRuleEngine On" "SecRuleEngine DetectionOnly" /etc/httpd/conf.d/modsecurity.conf
reemplazarEnArch "SecRuleEngine On" "SecRuleEngine DetectionOnly" /opt/kalan/standard/modsecurity.standard

echo "### kalan" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "AllowUsers servidor root" >> /etc/ssh/sshd_config
echo "" >> /etc/ssh/sshd_config
#cat /etc/ssh/sshd_config

sudo firewall-cmd --permanent --list-all
#sudo systemctl restart network.service
#sudo systemctl restart firewalld.service
#firewall-cmd --get-services
echo "MODO:MANTENIMIENTO" > /tmp/kalan-modo
/opt/kalan/scripts/crear-banners.sh
EOF
chmod +x /opt/kalan/scripts/kalan-modo-mantenimiento.sh
#####SCRIPT##### kalan-modo-mantenimiento.sh


#####SCRIPT##### kalan-hardening.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-hardening.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
pruebaLib
systemctl daemon-reload
sudo systemctl stop httpd
sudo systemctl stop web2pyd

echo "Espere un momento. cambiando a MODO PRODUCCION..."
sudo firewall-cmd --zone=public --permanent --remove-service=ssh
sudo firewall-cmd --zone=public --permanent --remove-service=http
sudo firewall-cmd --zone=public --permanent --remove-service=https
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
sudo firewall-cmd --permanent --zone=public --add-port=2222/tcp
sudo firewall-cmd --permanent --zone=public --remove-port=8080/tcp
sudo firewall-cmd --permanent --zone=public --remove-port=8888/tcp
firewall-cmd --reload

firewall-cmd --get-default-zone
sudo firewall-cmd --permanent --list-all
#sudo systemctl restart network.service
#sudo systemctl restart firewalld.service
#firewall-cmd --get-services

if [ ! -e /etc/ssh/sshd_config.original ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original

fi
if [ ! -e /opt/kalan/standard/sshd_config.standard ]; then

   cp -rf /etc/ssh/sshd_config.original /opt/kalan/standard/sshd_config.standard

fi
clear
echo "configurando selinux y ssh. Espere por favor..."
semanage port -a -t ssh_port_t -p tcp 2222
yes | \cp -rf /opt/kalan/standard/sshd_config.standard /etc/ssh/sshd_config
reemplazarEnArch "Port 2222" "Port 22" /etc/ssh/sshd_config
reemplazarEnArch "#Port 22" "Port 2222" /etc/ssh/sshd_config
reemplazarEnArch "#Protocol 2" "Protocol 2" /etc/ssh/sshd_config
reemplazarEnArch "#Banner none" "Banner /etc/issue.net" /etc/ssh/sshd_config
####activar bloqueos
reemplazarEnArch "SecRuleEngine DetectionOnly" "SecRuleEngine On" /etc/httpd/conf.d/modsecurity.conf
reemplazarEnArch "SecRuleEngine DetectionOnly" "SecRuleEngine On" /opt/kalan/standard/modsecurity.standard
echo "### kalan" >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "AllowUsers servidor" >> /etc/ssh/sshd_config
echo "" >> /etc/ssh/sshd_config
#cat /etc/ssh/sshd_config
echo "####################" > /etc/sysctl.d/kalan-sysctl.conf
echo "# Agregado kalan" >> /etc/sysctl.d/kalan-sysctl.conf
echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.d/kalan-sysctl.conf
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/kalan-sysctl.conf
echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.d/kalan-sysctl.conf
echo "# Fin Agregado kalan" >> /etc/sysctl.d/kalan-sysctl.conf
echo "MODO:PRODUCCION" > /tmp/kalan-modo
/opt/kalan/scripts/crear-banners.sh
EOF
chmod +x /opt/kalan/scripts/kalan-hardening.sh
ln -sf /opt/kalan/scripts/kalan-hardening.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-hardening.sh

#####SCRIPT##### reemplazar-ip-en-scripts.sh
cat << 'EOF' > /opt/kalan/scripts/reemplazar-ip-en-scripts.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
pruebaLib
KALAN_IP=$(/opt/kalan/scripts/get-ip-address.sh)
KALAN_HOSTNAME=$HOSTNAME

clear
echo "---------------------------------------------------------------------------"
echo " "
echo "Actualizando scripts para ip $KALAN_IP   host: $KALAN_HOSTNAME"
echo " "
echo "---------------------------------------------------------------------------"

###Asigna lo necesario a la instalacion de apache en /etc/httpd/conf.d/ZZZ-kalan-httpd.conf

DESTINO_PROXY_DEFAULT=$(kalan-var "DESTINO_PROXY_DEFAULT")
/opt/kalan/scripts/asignar-host-httpd.sh "$1" "$2" "$DESTINO_PROXY_DEFAULT"
###
yes | \cp -rf /opt/kalan/standard/web2pyd.systemctl.standard /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_IP##" "$2" /etc/systemd/system/web2pyd.service
reemplazarEnArch "##KALAN_WEB2PY_PORT##" "8888" /etc/systemd/system/web2pyd.service
yes | \cp -rf /opt/kalan/standard/hosts.standard /etc/hosts
reemplazarEnArch "##KALAN_IP##" "$2" /etc/hosts
reemplazarEnArch "##KALAN_HOSTNAME##" "$1" /etc/hosts
echo "$KALAN_IP" > /tmp/ip_web
echo "-------------------------------------------------------------------------------"
echo " "
echo "Actualización Terminada. Reinicie el Equipo."
echo "Para generar certificado SSL TLS ejecute 'crear-cert-apache.sh' "
echo "REINICIE EL EQUIPO PARA QUE LOS CAMBIOS SURTAN EFECTO "
echo "______________________________________________________________________________"

EOF

chmod +x /opt/kalan/scripts/reemplazar-ip-en-scripts.sh
ln -sf /opt/kalan/scripts/reemplazar-ip-en-scripts.sh /usr/local/bin/
#####ENDSCRIPT##### reemplazar-ip-en-scripts.sh

#####SCRIPT##### crear-cert-apache.sh

cat << 'EOF' > /opt/kalan/scripts/crear-cert-apache.sh
#!/bin/bash
# Generar y proteger certificado
echo " "
echo "______________________________________________________________________________"
echo " "
echo "Creacion de certificado SSL/TLS para servidor web apache"
echo "Complete los datos que se solicitan"
echo " "
echo " - Crear Certificado Autofirmado"
# Verify ssl directory exists
if [ ! -d "/etc/httpd/ssl" ]; then
    mkdir -p /etc/httpd/ssl
fi
certCN=$1
openssl genrsa -des3 -passout pass:x -out /etc/httpd/ssl/certif.pass.key 2048
openssl rsa -passin pass:x -in /etc/httpd/ssl/certif.pass.key -out /etc/httpd/ssl/self_signed.key
rm /etc/httpd/ssl/certif.pass.key
openssl req -new -key /etc/httpd/ssl/self_signed.key -out /etc/httpd/ssl/self_signed.csr -subj "/C=MX/ST=Mexico/L=DF/O=seguraxes/OU=dlintec/CN=$certCN"
openssl x509 -req -days 1000 -in /etc/httpd/ssl/self_signed.csr -signkey /etc/httpd/ssl/self_signed.key -out /etc/httpd/ssl/self_signed.cert
chmod 400 /etc/httpd/ssl/self_signed.*
EOF
chmod +x /opt/kalan/scripts/crear-cert-apache.sh
ln -sf /opt/kalan/scripts/crear-cert-apache.sh /usr/local/bin/
#####ENDSCRIPT##### crear-cert-apache.sh

#####SCRIPT##### kalan-chmod.sh
cat << 'EOF' >/opt/kalan/scripts/kalan-chmod.sh
#chgrp -R servidor /var/log/httpd
chmod -R 660 /var/log/httpd
chgrp -R servidor /opt
chmod -R 775 /opt
chmod -R 775 /opt/web-apps
chgrp -R servidor /opt/kalan
chmod -R 770 /opt/kalan
chown -R kalan:kalan /opt/web-apps/web2py


chgrp -R kalan /opt/web-apps
chown -R root:servidor /opt/kalan-instalacion.sh
chmod 770 /opt/kalan-instalacion.sh

chgrp -R kalan /opt/kalan/scripts
chmod +x /opt/kalan/scripts/kalan-lib.sh
chmod +x /opt/kalan/scripts/crear-banners.sh
chmod +x /opt/kalan/scripts/get-ip-address.sh
chmod +x /opt/kalan/scripts/cambio-en-red.sh
#chmod +x /opt/kalan/scripts/detectar-tarjetas-de-red

chmod +x /opt/kalan/scripts/seleccionar-red.sh
#chmod +x /opt/kalan/scripts/ajustes-de-red
chmod +x /opt/kalan/scripts/kalan-actualizar.sh
chown servidor /opt/kalan/scripts/kalan-actualizar.sh
chmod +x /opt/kalan/scripts/configurar-red.sh

chmod +x /opt/kalan/standard/web2pyd.systemctl.standard
chmod +x /opt/kalan/scripts/instalar-modsecurity.sh


chmod +x /opt/kalan/scripts/kalan-chmod.sh
chmod +x /opt/kalan/scripts/crear-cert-apache.sh
chmod +x /opt/kalan/scripts/reemplazar-ip-en-scripts.sh

chown -R kalan:kalan /opt/kalan
chown -R kalan:kalan /opt/kalan-data/conf
chmod -R 770 /opt/kalan

usermod -a -G servidor servidor
usermod -a -G wheel servidor
usermod -a -G apache servidor
usermod -a -G adm servidor
usermod -a -G tomcat servidor
usermod -a -G mysql servidor
usermod -a -G kalan servidor
usermod -a -G postgres servidor
usermod -a -G mongod servidor
usermod -a -G shutdown servidor

EOF

chmod +x /opt/kalan/scripts/kalan-chmod.sh
ln -sf /opt/kalan/scripts/kalan-chmod.sh /usr/local/bin/



#####ENDSCRIPT##### kalan-chmod.sh

#####SCRIPT##### /opt/kalan/scripts/kalan-aplicacion-default.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-aplicacion-default.sh
#!/bin/bash
cat << ROUTESEOF > /opt/web-apps/web2py/routes.py
routers = dict(
    BASE = dict(
        default_application='$1',
        root_static = ['favicon.ico', 'robots.txt','sw-import.js','precache.json','manifest.json'],
    )
)
ROUTESEOF
chown kalan:kalan /opt/web-apps/web2py/routes.py
EOF
chmod +x /opt/kalan/scripts/kalan-aplicacion-default.sh
ln -sf /opt/kalan/scripts/kalan-aplicacion-default.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-aplicacion-default.sh

#####SCRIPT##### kalan-instalar-escritorio.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-instalar-escritorio.sh
#!/bin/bash

#yum -y groups install "GNOME Desktop"
#systemctl set-default graphical.target
#sudo systemctl isolate graphical.target

sudo yum -y groupinstall "GNOME Desktop" "Graphical Administration Tools"
sudo yum -y install epel-release
sudo yum install -y dconf-editor gnome-shell-browser-plugin alacarte gnome-tweak-tool
sudo yum -y install firefox filezilla gedit gnome-packagekit gnome-system-monitor
cd /opt/kalan/ws
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum -y localinstall google-chrome-stable_current_x86_64.rpm

#rm '/etc/systemd/system/default.target'
#ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'
#ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target


#sudo yum -y groupinstall "X Window system"
#sudo yum install -y cinnamon gdm liberation* gnome-terminal gnome-icon-theme-legacy.noarch
#echo "exec /usr/bin/cinnamon-session" >> ~/.xinitrc
#ln -s /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
#sudo yum -y install firefox filezilla gedit gnome-packagekit gnome-system-monitor


#sudo yum groups install "GNOME Desktop"
#sudo yum -y install lightdm

# yum -y install epel-release

# sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo # set [priority=5]
# sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo # for another way, change to [enabled=0] and use it only when needed
# yum --enablerepo=epel install [Package] # if [enabled=0], input a command to use the repository

#sudo systemctl isolate graphical.target
#sudo systemctl set-default graphical.target
#sudo systemctl start graphical.target

EOF
chmod +x /opt/kalan/scripts/kalan-instalar-escritorio.sh
#####ENDSCRIPT##### kalan-instalar-escritorio.sh



#####SCRIPT##### kalan-clonar-sistema.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-clonar-sistema.sh
#!/bin/bash
#(
LOG_FILE=/tmp/kalan-mitosis.log
source /opt/kalan/scripts/kalan-lib.sh
echo "ESPERE. CONSTRUYENDO IMAGEN DE INSTALACION en carpeta $1...  "
if [ ! -d "/root/kickstart_build/utils" ]; then
	sudo mkdir -p /root/kickstart_build/isolinux
	sudo mkdir -p /root/kickstart_build/isolinux/images
	sudo mkdir -p /root/kickstart_build/isolinux/ks
	sudo mkdir -p /root/kickstart_build/isolinux/LiveOS
	sudo mkdir -p /root/kickstart_build/isolinux/Packages
	sudo mkdir -p /root/kickstart_build/utils
	sudo mkdir -p /root/kickstart_build/all_rpms
	sudo mkdir -p /root/kickstart_build/isolinux/postinstall
fi
cd /root/kickstart_build/isolinux
if [ ! -e /root/kickstart_build/isolinux/isolinux.bin ];then
	sudo mkdir /mnt/DVD
    sudo mount -r /dev/sr0 /mnt/DVD
	echo "Copiando disco media de Sistema operativo..."
	sudo cp -rf /mnt/DVD/images /root/kickstart_build/isolinux/
	sudo cp -rf /mnt/DVD/isolinux /root/kickstart_build/
	sudo cp -rf /mnt/DVD/LiveOS /root/kickstart_build/isolinux/
	sudo cp -rf /mnt/DVD/repodata/*-c7-x86_64-comps.xml.gz /root/kickstart_build/comps.xml.gz
	cd /root/kickstart_build/
	sudo rm -rf comps.xml
	sudo gunzip comps.xml.gz
fi


cat << 'EOFKS' > /root/kickstart_build/isolinux/ks/kskalan-pre.cfg.standard

#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=latam --xlayouts='latam','us','es'
# System language
lang es_MX.UTF-8 --addsupport=en_US.UTF-8

# Network information
network --onboot yes --bootproto dhcp
network --device=link --onboot yes --bootproto dhcp --hostname=kalan.org
# Root password
#rootpw --iscrypted ########
# System timezone
timezone America/Mexico_City --isUtc --ntpservers=0.centos.pool.ntp.org,1.centos.pool.ntp.org,2.centos.pool.ntp.org,3.centos.pool.ntp.org
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
#clearpart --none --initlabel

%packages
#@^minimal
@core
#@security-tools
kexec-tools
firewalld
EOFKS

cat << 'EOFKS' > /root/kickstart_build/isolinux/ks/kskalan-post.cfg.standard

%end

%addon org_fedora_oscap
    content-type = scap-security-guide
    profile = standard
%end
%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%post --nochroot

#!/bin/sh

#set -x -v
#exec 1>/mnt/sysimage/root/kickstart-stage1.log 2>&1

echo "==> copying files from media to install drive..."
#cp -r /run/install/repo/postinstall/opt /mnt/sysimage/opt
mkdir /mnt/sysimage/opt/kalan

cp -r /run/install/repo/postinstall/opt/kalan-instalacion.sh /mnt/sysimage/opt
mkdir -p /mnt/sysimage/root/kickstart_build

rsync -aAXv /run/install/repo/* /mnt/sysimage/root/kickstart_build/isolinux

rsync -aAXv /run/install/repo/postinstall/opt/kalan/* /mnt/sysimage/opt/kalan

%end

%post

#!/bin/sh

#set -x -v
#exec 1>/root/kickstart-stage2.log 2>&1
chmod +x /opt/kalan-instalacion.sh
ln -sf /opt/kalan-instalacion.sh /usr/local/bin/
ls -l /opt/kalan
cd /
echo "/opt/kalan-instalacion.sh postinstall" >> /root/.bashrc
rm -f /opt/kalan-data/conf/flag_postinstall


echo "______________________________________________________________________________" >> /etc/issue
echo " " >> /etc/issue
echo "      CONFIGURACION INICIAL kalan 7                     " > /etc/issue
echo "______________________________________________________________________________" >> /etc/issue
echo "                                                            " >> /etc/issue
echo "      El sistema se prepara para configurarse por 1a vez.   " >> /etc/issue
echo "      Ingrese como root y siga las instrucciones.           " >> /etc/issue
echo "      Le pediremos ingresar varias claves de administrador  " >> /etc/issue
echo "      durante el proceso.                                   " >> /etc/issue
echo "______________________________________________________________________________" >> /etc/issue
echo " " >> /etc/issue
cp -rf /etc/issue /etc/issue.net
%end

EOFKS




##cp -rf /root/anaconda-ks.cfg /root/kickstart_build/isolinux/ks/ks.cfg
echo "Analizando paquetes instalados..."

archivoinstalados='/root/kickstart_build/utils/instalados.txt'

rpm -qa >/root/kickstart_build/utils/instalados.txt

echo "Verificando modulos de python instalados..."

/usr/local/bin/pip2.7 list>/opt/kalan/sw/lista_python
cd /opt/kalan/sw/
mkdir -p /opt/kalan/sw/pip
>/root/kickstart_build/utils/kalan-python-instalados.txt

filelines=`cat /opt/kalan/sw/lista_python`
for line in $filelines ; do
    if [[ "$line" != "("* ]];then
		paquete=${line%(*}

		var2=${line#*(}
		echo "-------------------------------------------------------------------------------"
		echo "verificando paquete instalado pip: $line"
		echo $paquete >> /root/kickstart_build/utils/kalan-python-instalados.txt
		#/usr/local/bin/pip2.7 install --download /opt/kalan/sw/pip $paquete
	else
	   echo "Version $paquete"
	fi
done
if [[ "$(/opt/kalan/scripts/get-internet.sh)" == "1" ]];then
	echo "------------------------------------------------------------------------------"
	echo "               Descargando paquetes si no estan localmente"
	echo "------------------------------------------------------------------------------"
	/usr/local/bin/pip2.7 install --download /opt/kalan/sw/pip -r /root/kickstart_build/utils/kalan-python-instalados.txt
fi
echo "------------------------------------------------------------------------------"
echo "               Creando archivos de configuracion para imagen iso"
echo "------------------------------------------------------------------------------"
KSKALAN_CFG="/root/kickstart_build/isolinux/ks/kskalan.cfg"
echo " " > $KSKALAN_CFG
cat /root/kickstart_build/isolinux/ks/kskalan-pre.cfg.standard >> $KSKALAN_CFG
echo " " >> $KSKALAN_CFG
cat /root/kickstart_build/utils/instalados.txt >> $KSKALAN_CFG
echo " " >> $KSKALAN_CFG
cat /root/kickstart_build/isolinux/ks/kskalan-post.cfg.standard >> $KSKALAN_CFG
echo " " >> $KSKALAN_CFG

reemplazarEnArch "kernel-3.1" "#kernel-3.1" $KSKALAN_CFG
reemplazarEnArch "gpg-pubkey" "#gpg-pubkey" $KSKALAN_CFG
reemplazarEnArch "chrony" "#chrony" $KSKALAN_CFG
reemplazarEnArch "crony" "#crony" $KSKALAN_CFG
reemplazarEnArch "mongo" "#mongo" $KSKALAN_CFG
reemplazarEnArch "kernel-devel" "#kernel-devel" $KSKALAN_CFG
#reemplazarEnArch "#mongodb-org-3" "mongodb-org-3" $KSKALAN_CFG

if [ ! -e /root/kickstart_build/utils/resolve.pl ];then
cat << 'EOFPERL' > /root/kickstart_build/utils/resolve.pl
#!/usr/bin/perl

my ($rpm_src_path, $rpm_dst_path, $arch) = @ARGV;

if (!-e $rpm_src_path)
{
    print_usage ("RPM source path '$rpm_src_path' does not exist");
}
if (!-e $rpm_dst_path)
{
    print_usage ("RPM destination path '$rpm_dst_path' does not exist");
}
if (!$arch)
{
    print_usage ("Architecture not specified");
}

print "Scanning all RPMs for capabilities provided...\n";
%providers = {};
open(my $fh_providers, '>/tmp/providers.txt');
foreach (<$rpm_src_path/*.rpm>)
{
    if (!m#(noarch|$arch)\.rpm$#)
    {
        next;
    }

    $rpm = $_;

    print ".";
    print $fh_providers "$rpm\n";

    $cmd = "rpm -q --provides -p $rpm 2>/dev/null";
    $output = `$cmd`;

    @lines = split ("\n", $output);

    foreach (@lines)
    {
        if (m#(.+)\s+=\s+\d#)
        {
            $capability = $1;
        }
        else
        {
            $capability = $_;
        }

        $rpm =~ m#([^/]+$)#;
        $rpm = $1;

        if ($providers{$capability} && ($providers{$capability} != $rpm))
        {
            print "WARNING: $capability is provided by " . $providers{$capability} . " and $rpm\n";
        }

        print $fh_providers "  $capability\n";
        $providers{$capability} = $rpm;
    }
}
close $fh_providers;

print "\n";

@queue = ();
%copied_packages = {};
foreach (<$rpm_dst_path/*rpm>)
{
    push (@queue, $_);
    my ($filename) = (m#/([^/]+)$#);
    my ($package_name) = ($filename =~ m#/(.+?)-\d#);
    $copied_packages{$package_name} = 1;
}

while (@queue)
{
    $rpm_name = pop (@queue);

    print "checking $rpm_name...\n";
    $cmd = "rpm -qRp $rpm_name 2>/dev/null | sort | uniq";
    #print "$cmd\n";
    @output = `$cmd`;

    foreach (@output)
    {
        s/^\s+//;
        s/\s+$//;
        s/\s+[<>=].+$//;  # strip off stuff like " >= 2003a"

        if ($providers{$_})
        {
            $new_path = "$rpm_dst_path/" . $providers{$_};

            if (-e $new_path)
            {
                #### already have this RPM in the directory...
                next;
            }
            print " requires $_ ==> " . $providers{$_} . "\n";

            push (@queue, $new_path);

            $newrpm = "$rpm_src_path/" . $providers{$_};
            $cmd = "cp $newrpm $rpm_dst_path";
            print "  $cmd\n";
            `$cmd 2>&1`;
        }
    }
}

sub print_usage
{
    my ($msg) = @_;

    ($msg) && print "$msg\n\n";

    print <<__TEXT__;
follow_deps.pl rpm_src_path rpm_dst_path arch

    rpm_src_path    the full path to the directory of all RPMs from the distro

    rpm_dst_path    the full path to the directory where you want to copy
                    the RPMs for your kickstart

    arch            the target system architecture (e.g. x86_64)


__TEXT__

    exit;
}


EOFPERL
chmod +x /root/kickstart_build/utils/resolve.pl
fi


cat << 'EOFCFG' > /root/kickstart_build/isolinux/isolinux.cfg
default vesamenu.c32
timeout 600

display boot.msg

# Clear the screen when exiting the menu, instead of leaving the menu displayed.
# For vesamenu, this means the graphical background is still displayed without
# the menu itself for as long as the screen remains in graphics mode.
menu clear
menu background splash.png
menu title Digital Intelligence Server v##VERSION_KALAN##
menu vshift 8
menu rows 18
menu margin 8
#menu hidden
menu helpmsgrow 15
menu tabmsgrow 13

# Border Area
menu color border * #00000000 #00000000 none

# Selected item
menu color sel 0 #ffffffff #00000000 none

# Title bar
menu color title 0 #ff7ba3d0 #00000000 none

# Press [Tab] message
menu color tabmsg 0 #ff3a6496 #00000000 none

# Unselected menu item
menu color unsel 0 #84b8ffff #00000000 none

# Selected hotkey
menu color hotsel 0 #84b8ffff #00000000 none

# Unselected hotkey
menu color hotkey 0 #ffffffff #00000000 none

# Help text
menu color help 0 #ffffffff #00000000 none

# A scrollbar of some type? Not sure.
menu color scrollbar 0 #ffffffff #ff355594 none

# Timeout msg
menu color timeout 0 #ffffffff #00000000 none
menu color timeout_msg 0 #ffffffff #00000000 none

# Command prompt text
menu color cmdmark 0 #84b8ffff #00000000 none
menu color cmdline 0 #ffffffff #00000000 none

# Do not display the actual menu unless the user presses a key. All that is displayed is a timeout message.

menu tabmsg Flechas del teclado y ENTER para elegir.

menu separator # insert an empty line
menu separator # insert an empty line
label ks
  menu label ^Instalar Digital Intelligence Server
  menu default
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 inst.ks=cdrom:/dev/cdrom:/ks/kskalan.cfg

menu separator # insert an empty line

# utilities submenu
menu begin ^SolucionarProblemas
  menu title Solucionar Problemas

label vesa
  menu indent count 5
  menu label Instalar en modo grafico ^basico
  text help
        Intente con esta opcion si ha tenido problemas durante
        la instalacion.
  endtext
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 inst.ks=cdrom:/dev/cdrom:/ks/kskalan.cfg xdriver=vesa nomodeset quiet

label rescue
  menu indent count 5
  menu label ^Rescatar un sistema
  text help
        If the system will not boot, this lets you access files
        and edit config files to try to get it booting again.
  endtext
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 inst.ks=cdrom:/dev/cdrom:/ks/kskalan.cfg rescue quiet

label memtest
  menu label Ejecutar prueba de ^memoria
  text help
        If your system is having issues, a problem with your
        systems memory may be the cause. Use this utility to
        see if the memory is working correctly.
  endtext
  kernel memtest

menu separator # insert an empty line

label local
  menu label Iniciar de disco ^local
  localboot 0xffff

menu separator # insert an empty line
menu separator # insert an empty line

label returntomain
  menu label Regresar a ^menu principal
  menu exit

menu end
EOFCFG

VERSION_ACTUAL=$(kalan-var "VERSION_ACTUAL")
reemplazarEnArch "##VERSION_KALAN##" "$VERSION_ACTUAL" /root/kickstart_build/isolinux/isolinux.cfg
echo "------------------------------------------------------------------------------"
echo "               Reuniendo paquetes RPM"
echo "------------------------------------------------------------------------------"

cd /root/kickstart_build/utils
filelines=`cat $archivoinstalados`
echo Start
cd /root/kickstart_build/isolinux/Packages
rm -rf /root/kickstart_build/utils/faltantes.txt
for line in $filelines ; do
	echo "-------------------------------------------------------------"
	echo "$line"
	if [ ! -e /root/kickstart_build/isolinux/Packages/$line.rpm ];then
	     if [ -e /mnt/DVD/Packages/$line.rpm ];then
		    echo "copiando $line.rpm de media local"
		    cp /mnt/DVD/Packages/$line.rpm /root/kickstart_build/isolinux/Packages/
		 else
		    echo "Agregando paquete a faltantes $line"
			echo $line >> /root/kickstart_build/utils/faltantes.txt
    	    #yumdownloader --resolve $line
		 fi
	else
	    echo "Ya existe $line"
	fi
	#cp -rf /root/kickstart_build/isolinux/Packages/$line.rpm /root/kickstart_build/all_rpms/$line.rpm
done
echo "------------------------------------------------------------------------------"
echo "               Descargando faltantes....."
echo "------------------------------------------------------------------------------"
if [[ -e /root/kickstart_build/utils/faltantes.txt ]];then
	yumdownloader --resolve $(cat /root/kickstart_build/utils/faltantes.txt)
else
	echo "Paquetes Ok. No hay faltantes."
fi
echo "------------------------------------------------------------------------------"
echo "               sincronizando paquetes....."
echo "------------------------------------------------------------------------------"

rsync -aAXv --exclude '*.iso' /root/kickstart_build/isolinux/Packages/* /root/kickstart_build/all_rpms/

/root/kickstart_build/utils/resolve.pl /root/kickstart_build/all_rpms /root/kickstart_build/isolinux/Packages x86_64
# limpiar
echo "::::Eliminando y recreando carpeta all_rpms "
rm -rf /root/kickstart_build/all_rpms
mkdir -p /root/kickstart_build/all_rpms

if [ ! -e /root/kickstart_build/isolinux/splashorig.png ];then
    cp /root/kickstart_build/isolinux/splash.png /root/kickstart_build/isolinux/splashorig.png
fi

#copiar imagen
cp -rf /opt/kalan/media/splash2.png /root/kickstart_build/isolinux/splash2.png
cp -rf /root/kickstart_build/isolinux/splash2.png /root/kickstart_build/isolinux/splash.png
#sincronizar carpetas de /opt/kalan donde estan aplicaciones
echo "------------------------------------------------------------------------------"
echo "               copiando carpetas de opt..."
echo "------------------------------------------------------------------------------"

rsync -aAXv --delete --exclude '*.iso' /opt/* /root/kickstart_build/isolinux/postinstall/opt

rm -rf /root/kickstart_build/isolinux/postinstall/opt/kalan/sw/pip/TRANS.TBL
rm -rf /root/kickstart_build/isolinux/postinstall/opt/kalan/sw/Python-2.7.10/
rm -rf /root/kickstart_build/isolinux/postinstall/opt/kalan/sw/modsecurity-2.9.0/

cd /root/kickstart_build/isolinux
createrepo -g /root/kickstart_build/comps.xml .
cd /root/kickstart_build

chmod 664 isolinux/isolinux.bin
mkisofs -o $1/kalan-$VERSION_ACTUAL.iso -b isolinux.bin -c boot.cat -no-emul-boot -V 'CentOS 7 x86_64' -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
echo " "
echo "      Se ha creado un archivo de imagen iso para DVD en:"
echo "      $1/kalan-$VERSION_ACTUAL.iso"
echo " "
#) 2>&1 | tee /var/log/kalan/clone.log
EOF

chmod +x /opt/kalan/scripts/kalan-clonar-sistema.sh
ln -sf /opt/kalan/scripts/kalan-clonar-sistema.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-clonar-sistema.sh

#####SCRIPT##### kalan.sh
cat << 'EOF' > /opt/kalan/scripts/kalan.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh

	case $1 in
	menu)
	   echo "A la orden! ejecutando $1"
	   /opt/kalan/scripts/kalan-menu.sh
	;;
	*)  echo "No entiendo $1";
		;;
	esac

EOF
chmod +x /opt/kalan/scripts/kalan.sh
ln -sf /opt/kalan/scripts/kalan.sh /usr/local/bin/kalan
#####ENDSCRIPT##### kalan

#####SCRIPT##### kalan-web2py-admin.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-web2py-admin.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
cd /opt/web-apps/web2py
PW_w2p=$(doublePassword "Clave admin infraestructura web")
echo "$PW_w2p" |python2.7 -c "from gluon.main import save_password; save_password(raw_input('introduzca clave admin: '),8888)" --stdin

EOF
chmod +x /opt/kalan/scripts/kalan-web2py-admin.sh
ln -sf /opt/kalan/scripts/kalan-web2py-admin.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-web2py-admin.sh

#####SCRIPT##### instalar-meanstack.sh
cat << 'EOF' > /opt/kalan/scripts/instalar-meanstack.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
(
cd /opt/kalan/sw
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -ivh epel-release-7-5.noarch.rpm
sudo yum -y install nodejs npm
) 2>&1 | tee /var/log/kalan/instalar-meanstack.sh.log
EOF
chmod +x /opt/kalan/scripts/instalar-meanstack.sh
ln -sf /opt/kalan/scripts/instalar-meanstack.sh /usr/local/bin/
#####ENDSCRIPT##### instalar-meanstack.sh

#####SCRIPT##### crear-carpetas.sh
cat << 'EOF' > /opt/kalan/scripts/crear-carpetas.sh
#!/bin/bash

if [ ! -d /opt/kalan/scripts/ ]; then
    mkdir -p /opt/kalan/scripts/
fi
if [ ! -d /opt/kalan/standard ]; then
    mkdir -p /opt/kalan/standard
fi

if [ ! -d /opt/kalan/act/ ]; then
    mkdir -p  /opt/kalan/act/
fi
if [ ! -d /opt/kalan/sw/ ]; then
    mkdir -p /opt/kalan/sw/
fi
if [ ! -d /opt/kalan/standard ]; then
    mkdir -p /opt/kalan/standard
fi
if [ ! -d /opt/kalan/var ]; then
    mkdir -p /opt/kalan/var
fi
if [ ! -d /opt/kalan/tmp ]; then
    mkdir -p /opt/kalan/tmp
fi
if [ ! -d /opt/kalan/media ]; then
    mkdir -p /opt/kalan/media
fi
# Create web-apps directory, if required
if [ ! -d "/opt/web-apps" ]; then
    mkdir -p /opt/web-apps
    chmod -R 775 /opt/web-apps
fi

if [ ! -d /var/log/kalan ]; then
    mkdir -p /var/log/kalan/
fi
if [ ! -d /opt/kalan-data ]; then
    mkdir -p /opt/kalan-data
fi


if [ ! -d "/root/kickstart_build/utils" ]; then
	mkdir -p /root/kickstart_build/isolinux
	mkdir -p /root/kickstart_build/isolinux/images
	mkdir -p /root/kickstart_build/isolinux/ks
	mkdir -p /root/kickstart_build/isolinux/LiveOS
	mkdir -p /root/kickstart_build/isolinux/Packages
	mkdir -p /root/kickstart_build/utils
	mkdir -p /root/kickstart_build/all_rpms
	mkdir -p /root/kickstart_build/isolinux/postinstall
fi

EOF
chmod +x /opt/kalan/scripts/crear-carpetas.sh
ln -sf /opt/kalan/scripts/crear-carpetas.sh /usr/local/bin/
#####ENDSCRIPT##### crear-carpetas.sh

#####SCRIPT##### instalar-docker.sh
cat << 'EOF' > /opt/kalan/scripts/instalar-docker.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
#(
if [ ! -d /opt/kalan-data/kalan-data-container ]; then
    mkdir -p /opt/kalan-data/kalan-data-container
fi

if [ ! -e /etc/yum.repos.d/docker.repo ];then
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF1'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF1
fi
echo "installing docker-engine"
sudo yum -y install docker-engine git
sudo service docker start
sudo systemctl enable docker
#docker rm -v $(docker ps -a -q)
#docker rmi $(docker images -q)

curl -L https://github.com/docker/machine/releases/download/v0.5.3/docker-machine_linux-amd64 >/usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine
curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#docker create -v / --name kalan-data-container centos:latest /bin/true

#docker create -d --volumes-from kalan-data-container --name kalan centos:latest

#cd ~/
#git clone --recursive https://github.com/jfrazelle/.vim.git .vim
#ln -sf $HOME/.vim/vimrc $HOME/.vimrc

#) 2>&1 | tee /var/log/kalan/instalar-docker.sh.log
EOF
chmod +x /opt/kalan/scripts/instalar-docker.sh
ln -sf /opt/kalan/scripts/instalar-docker.sh /usr/local/bin/
#####ENDSCRIPT##### instalar-docker.sh

#chown -R kalan:kalan /opt/kalan-data/conf

#####SCRIPT##### kalan-update.sh
cat << 'EOF' > /opt/kalan/scripts/kalan-update.sh
#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh
#(
cd /opt/
git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /opt/kalan/kalan-instalacion.sh
/opt/kalan/kalan-instalacion.sh scripts
#) 2>&1 | tee /var/log/kalan/instalar-meanstack.sh.log
EOF
chmod +x /opt/kalan/scripts/kalan-update.sh
ln -sf /opt/kalan/scripts/kalan-update.sh /usr/local/bin/
#####ENDSCRIPT##### kalan-update.sh

}


#####ENDFUNCTION##### f_create_scripts



##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################

#####FUNCION##### f_config_sys

function f_config_sys {

source /opt/kalan/scripts/kalan-lib.sh

if [ ! -e /etc/pam.d/su.original ]; then
    cp /etc/pam.d/su /etc/pam.d/su.original
fi
cat << 'EOF' > /etc/pam.d/su
#%PAM-1.0
auth            sufficient      pam_rootok.so
# Uncomment the following line to implicitly trust users in the "wheel" group.
#auth           sufficient      pam_wheel.so trust use_uid
# Uncomment the following line to require a user to be in the "wheel" group.
auth            required        pam_wheel.so use_uid
auth            include         system-auth
account         sufficient      pam_succeed_if.so uid = 0 use_uid quiet
account         include         system-auth
password        include         system-auth
session         include         system-auth
session         optional        pam_xauth.so
EOF
reemplazarEnArch  "#auth            required        pam_wheel.so use_uid" "auth            required        pam_wheel.so use_uid" /etc/pam.d/su

}
#####ENDFUNCTION##### f_config_sys

#####FUNCTION##### f_install

function f_install {
parametro="$1"
if [ "$parametro" == "postinstall" ];then
	filelines=$(ls /opt/kalan/scripts)
	for line in $filelines ; do
	    #echo "Creando link para script $line"
		/opt/kalan/scripts/kalan-registrar-script.sh /opt/kalan/scripts/$line
	done
else
	f_create_scripts
fi

/opt/kalan/scripts/crear-carpetas.sh
f_config_sys

source /opt/kalan/scripts/kalan-lib.sh
pruebaLib
KALAN_IP=$(/opt/kalan/scripts/get-ip-address.sh)
KALAN_WEB2PY_PORT=8888
KALAN_HOSTNAME=$HOSTNAME



yes | \cp -rf /opt/kalan/standard/hosts.standard /etc/hosts
reemplazarEnArch "##KALAN_IP##" "$KALAN_IP" /etc/hosts
reemplazarEnArch "##KALAN_HOSTNAME##" "$KALAN_HOSTNAME" /etc/hosts
/opt/kalan/scripts/crear-usuarios.sh
kalan-detener.sh web2pyd
#kalan-detener.sh httpd
#kalan-detener.sh tomcat

clear
echo "Parametro:$parametro"

/opt/kalan/scripts/instalar-paquetes.sh $1
/opt/kalan/scripts/instalar-postgres.sh
/opt/kalan/scripts/instalar-mongo.sh

systemctl start firewalld
systemctl enable firewalld
systemctl enable httpd
systemctl enable ntpd
systemctl start ntpd
cp /etc/localtime /root/old.timezone
rm -rf /etc/localtime
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
ntpdate -b -u time.nist.gov
/opt/kalan/scripts/instalar-python.sh $1

echo " - Configurar Apache "
# Create config
if [ -e /etc/httpd/conf.d/welcome.conf ]; then
    mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.disabled
fi

### respaldar conf original si no existe
if [ ! -e /etc/httpd/conf/httpd.original ]; then
    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.original
fi
cp /etc/httpd/conf/httpd.original /opt/kalan/standard/httpd.standard

/opt/kalan/scripts/instalar-web2py.sh
systemctl daemon-reload
/opt/kalan/scripts/instalar-modsecurity.sh
/opt/kalan/scripts/instalar-mlogc.sh


/opt/kalan/scripts/cambio-en-red.sh

echo "Procesando. Espera por favor..."
#permitir a apache establecer conexion (necesario para proxy)
setsebool -P httpd_can_network_connect=1
clear
echo " "
echo "______________________________________________________________________________"
echo " "
echo "      ADMINISTRADOR DE APLICACIONES"
echo "      Ingrese una nueva clave de administrador para entrar al"
echo "      modo de mantenimiento de infraestructura web de este sistema."
echo "      NOTA: La clave no se muestra mientras la teclea"
echo "            Teclee la nueva clave y pulse ENTER..."
echo " "
echo "______________________________________________________________________________"
cd /opt/web-apps/web2py
/opt/kalan/scripts/kalan-web2py-admin.sh
#PW_w2p=$(doublePassword "Clave admin infraestructura web")
#python2.7 -c "from gluon.main import save_password; save_password($PW_w2p,$KALAN_WEB2PY_PORT)"
#stty -echo
#python2.7 -c "from gluon.main import save_password; save_password(raw_input('introduzca clave admin: '),$KALAN_WEB2PY_PORT)"
#stty echo
clear
/opt/kalan/scripts/kalan-clonar-aplicacion.sh welcome kalan


/opt/kalan/scripts/kalan-aplicacion-default.sh kalan
clear
echo " "
echo "______________________________________________________________________________"
echo " "
echo "      Base de Datos: MONGO"
echo "      En el siguiente paso se le solicita ingresar una clave de administrador"
echo "      para el usuarui -servidor- de la base de datos Mongo. "
echo "            pulse ENTER para continuar a la captura de clave"
echo " "
echo "______________________________________________________________________________"
stty -echo
#read CONFIRM
stty echo
clear
CLAVE_MONGO=$(doublePassword "Clave usuario -servidor- en MongoDB")
clear
/opt/kalan/scripts/configurar-mongo.sh $CLAVE_MONGO
/opt/kalan/scripts/crear-cert-apache.sh $(hostname)
/opt/kalan/scripts/reemplazar-ip-en-scripts.sh $(hostname) $(get-ip-address.sh)
/opt/kalan/scripts/kalan-chmod.sh
/opt/kalan/scripts/kalan-hardening.sh

clear
if [ "$parametro" == "postinstall" ];then
    echo "Hola! kalan esta activo" > /opt/kalan-data/conf/flag_postinstall
	chown kalan:kalan /opt/kalan-data/conf/flag_postinstall
fi

echo " "
echo "______________________________________________________________________________"
echo "        FIN DE INSTALACION de host $KALAN_HOSTNAME"
echo "        Para conectarse via web use https://$KALAN_IP"
echo "______________________________________________________________________________"
echo "        Para conectarse con niveles de administrador a las interfases web"
echo "        es requisito usar tunel SSH. "
echo "        utilice los siguientes comandos para crear los tuneles necesarios: "
echo "______________________________________________________________________________"
echo "        INFRAESTRUCTURA WEB kalan python para administradores root"
echo "        Tunel    :  ssh -L $KALAN_WEB2PY_PORT:127.0.0.1:$KALAN_WEB2PY_PORT servidor@10.0.0.101 -p 2222"
echo "        Conectar :  http://127.0.0.1:$KALAN_WEB2PY_PORT"
echo "______________________________________________________________________________"
echo "        Para modificar reglas y excepciones de modsecurity edite: "
echo "        modsecurity_crs_99_excepciones.conf"
echo "        en la carpeta: /etc/httpd/modsecurity-crs/base_rules/"
echo "______________________________________________________________________________"
echo "        RECUERDE QUE SSH HA CAMBIADO AL PUERTO 2222"
echo "______________________________________________________________________________"
echo " "
echo "        FIN DE INSTALACION de host $KALAN_HOSTNAME :)"
echo " "
echo "        REINICIE EL EQUIPO POR FAVOR "
echo " "
echo "DONE" > /opt/kalan-data/conf/flag_install



if [ ! -e /etc/httpd/ssl/self_signed.cert ];then
 echo "ERROR: NO EXISTE CERTIFICADO SSL EN /etc/httpd/ssl/self_signed.cert"
fi
read -r -p "      Reiniciar el equipo ahora? [s/N] " response
case $response in
[sS][iI]|[sS]) clear;
  echo " "
  echo " "
  echo "Reiniciando. Espere..."
  sudo systemctl reboot;
  exit;
;;
*)  clear;
    exit;
;;
esac


}
#####ENDFUNCTION##### f_install



	#echo $(kalan-var "VERSION_ORIGINAL")
	#echo $(kalan-var "URL_ACTUALIZACION")
	#echo $(kalan-var "DESTINO_PROXY_DEFAULT")
	if [ "$PARAMETRO" == "postinstall" ];then
		  echo "Ejecutando Postinstalacion. Espere..."
		  rm -f /opt/kalan-data/conf/flag_postinstall
	      f_install $1

	   exit;
	else
	    if [ "$PARAMETRO" == "scripts" ];then
		    echo "parametro para solo crear scripts"
		    f_create_scripts
			source /opt/kalan/scripts/kalan-lib.sh
            replaceLinesThanContain "VERSION_ACTUAL" "VERSION_ACTUAL=$KALAN_VERSION" /opt/kalan-data/conf/kalan.conf

		else
			read -r -p "      Esta Seguro de realizar la instalacion? [s/N] " response
			case $response in
			[sS][iI]|[sS]) clear;
			  echo " "
			  echo " "
			  echo "Ejecutando instalacion completa. Espere..."
			  rm -f /opt/kalan-data/conf/flag_postinstall
			  rm -f /opt/kalan/conf/flag_install
			  f_install $1
			  exit;
			;;
			*)  clear;
				exit;
			;;
			esac
		fi
	fi

fi
}

main "$@"
