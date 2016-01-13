#!/bin/bash
#~/kalan/src/kregisterscript.sh
main() {
cadena="$1"
nombrecompleto="${cadena##*/}"
extension="${nombrecompleto##*.}"
solonombre="${nombrecompleto%%.*}"
chmod 755 $cadena
ln -sf ~/kalan/src/$nombrecompleto ~/kalan/bin/$solonombre
chmod 755  ~/kalan/bin/$solonombre
echo "$solonombre"
}

main "$@"

