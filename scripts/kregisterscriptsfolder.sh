#!/bin/bash
main() {
###script /var/kalan/scripts/kregisterscriptsfolder.sh
filelines=$(ls /var/kalan/scripts)
for line in $filelines ; do
    #echo "Creando link para script $line"
	/var/kalan/scripts/kregisterscript.sh /var/kalan/scripts/$line
done

}
main "$@"
