#!/bin/bash
main() {
parametro="$1"
if [ "$parametro" == "postinstall" ];then
	filelines=$(ls /opt/kalan/scripts)
	for line in $filelines ; do
	    #echo "Creando link para script $line"
		/opt/kalan/scripts/kalan-registrar-script.sh /opt/kalan/scripts/$line
	done

fi
}

main "$@"
