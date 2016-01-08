#!/bin/bash
main() {
###script ~/kalan/src/kregisterscriptsfolder.sh
filelines=$(ls ~/kalan/src)
for line in $filelines ; do
    #echo "Creando link para script $line"
	~/kalan/src/kregisterscript.sh ~/kalan/src/$line
done

}
main "$@"
