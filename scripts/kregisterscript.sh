#!/bin/bash
main() {
cadena="$1"
nombrecompleto="${cadena##*/}"
extension="${nombrecompleto##*.}"
solonombre="${nombrecompleto%%.*}"
chmod +x $cadena
ln -sf $cadena /usr/local/bin/$solonombre
echo "$solonombre"
}

main "$@"
