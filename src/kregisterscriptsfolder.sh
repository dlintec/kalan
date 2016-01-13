#!/bin/bash
main() {
###script ~/kalan/src/kregisterscriptsfolder.sh
filelines=$(ls ~/kalan/src)
if [ ! -d ~/bin ];then
   mkdir ~/bin
fi
for line in $filelines ; do
    #echo "Creando link para script $line"
	~/kalan/src/kregisterscript.sh ~/bin/$line
done

}
main "$@"
