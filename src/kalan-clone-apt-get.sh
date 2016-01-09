#!/bin/bash
#(

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="/home/$KALAN_USER/kalan"
KALAN_CLONE_DIR=$KALAN_DIR-data/clone
PATH_CACHE="/var/cache/apt/archives"
source $KALAN_DIR/src/kalan-lib.sh

LOG_FILE=/tmp/kalan-mitosis.log

echo "Building system image folder in $KALAN_CLONE_DIR...  "
if [ ! -d "$KALAN_CLONE_DIR" ]; then
    mkdir -p $KALAN_CLONE_DIR
fi
if ! [ -x "$(command -v systemback)" ]; then
  sudo add-apt-repository ppa:nemh/systemback
  sudo apt-get update
  sudo apt-get install systemback

fi
if [ ! -e $KALAN_CLONE_DIR/isolinux/isolinux.bin ];then
  #/media/tadeo/Ubuntu 14.04.3 LTS amd64
  if [[ ! -d /mnt/DVD ]];then
	   sudo mkdir /mnt/DVD
  fi
  sudo mount -r /dev/sr0 /mnt/DVD 2>/dev/null
  if [ ! -d /mnt/DVD/isolinux/ ];then
     echo "No installation media found on DVD. Insert one"
     echo "or rsync its root folder to $KALAN_CLONE_DIR/"
     exit 1
  else
    echo "Copying install media to image structure"
    sudo rsync -aAXv /mnt/DVD/* $KALAN_CLONE_DIR/
    exit
  fi

fi

cat << 'EOF_COMMENT' > tempcomment
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
mkdir /mnt/sysimage~/kalan

cp -r /run/install/repo/postinstall~/kalan-instalacion.sh /mnt/sysimage/opt
mkdir -p /mnt/sysimage/root/kickstart_build

rsync -aAXv /run/install/repo/* /mnt/sysimage/root/kickstart_build/isolinux

rsync -aAXv /run/install/repo/postinstall~/kalan/* /mnt/sysimage~/kalan

%end

%post

#!/bin/sh

#set -x -v
#exec 1>/root/kickstart-stage2.log 2>&1
chmod +x ~/kalan-instalacion.sh
ln -sf ~/kalan-instalacion.sh /usr/local/bin/
ls -l ~/kalan
cd /
echo "~/kalan-instalacion.sh postinstall" >> /root/.bashrc
rm -f ~/kalan-data/conf/flag_postinstall


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

/usr/local/bin/pip2.7 list>~/kalan/src/lista_python
cd ~/kalan/src/
mkdir -p ~/kalan/src/pip
>/root/kickstart_build/utils/kalan-python-instalados.txt

filelines=`cat ~/kalan/src/lista_python`
for line in $filelines ; do
    if [[ "$line" != "("* ]];then
		paquete=${line%(*}

		var2=${line#*(}
		echo "-------------------------------------------------------------------------------"
		echo "verificando paquete instalado pip: $line"
		echo $paquete >> /root/kickstart_build/utils/kalan-python-instalados.txt
		#/usr/local/bin/pip2.7 install --download ~/kalan/src/pip $paquete
	else
	   echo "Version $paquete"
	fi
done
if [[ "$(~/kalan/src/get-internet.sh)" == "1" ]];then
	echo "------------------------------------------------------------------------------"
	echo "               Descargando paquetes si no estan localmente"
	echo "------------------------------------------------------------------------------"
	/usr/local/bin/pip2.7 install --download ~/kalan/src/pip -r /root/kickstart_build/utils/kalan-python-instalados.txt
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

# limpiar
echo "::::Eliminando y recreando carpeta all_rpms "
rm -rf /root/kickstart_build/all_rpms
mkdir -p /root/kickstart_build/all_rpms

if [ ! -e /root/kickstart_build/isolinux/splashorig.png ];then
    cp /root/kickstart_build/isolinux/splash.png /root/kickstart_build/isolinux/splashorig.png
fi

#copiar imagen
cp -rf ~/kalan/media/splash2.png /root/kickstart_build/isolinux/splash2.png
cp -rf /root/kickstart_build/isolinux/splash2.png /root/kickstart_build/isolinux/splash.png
#sincronizar carpetas de ~/kalan donde estan aplicaciones
echo "------------------------------------------------------------------------------"
echo "               copiando carpetas de opt..."
echo "------------------------------------------------------------------------------"

rsync -aAXv --delete --exclude '*.iso' /var/* /root/kickstart_build/isolinux/postinstall/opt

rm -rf /root/kickstart_build/isolinux/postinstall~/kalan/src/pip/TRANS.TBL
rm -rf /root/kickstart_build/isolinux/postinstall~/kalan/src/Python-2.7.10/
rm -rf /root/kickstart_build/isolinux/postinstall~/kalan/src/modsecurity-2.9.0/

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
EOF_COMMENT
rm -rf tempcomment
