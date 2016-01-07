#!/bin/bash
main() {
cadena="$1"
nombrecompleto="${cadena##*/}"
extension="${nombrecompleto##*.}"
solonombre="${nombrecompleto%%.*}"
chmod 755 $cadena
ln -sf $cadena /usr/local/bin/$solonombre
chmod 755 /usr/local/bin/$solonombre
echo "$solonombre"
}

main "$@"
