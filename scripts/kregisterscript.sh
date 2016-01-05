#!/bin/bash
main() {
cadena="$1"
nombrecompleto="${cadena##*/}"
extension="${nombrecompleto##*.}"
solonombre="${nombrecompleto%%.*}"
chmod +x $1
ln -sf $1 /usr/local/bin/$solonombre
}

main "$@"
