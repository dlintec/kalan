#!/bin/bash
main() {
###script ~/kalan/scripts/kregisterscriptsfolder.sh
filelines=$(ls ~/kalan/scripts)
for line in $filelines ; do
    #echo "Creando link para script $line"
	~/kalan/scripts/kregisterscript.sh ~/kalan/scripts/$line
done

}
main "$@"
