#!/bin/bash

chmod +x configure

WITH_ONI=--with-oniguruma=$PREFIX
if [[ $(uname) =~ M.* ]]; then
  HOST=--host=x86_64-w64-mingw32
  pushd modules/oniguruma
    autoreconf -vfi
  popd
  PREFIX=${PREFIX}/Library/mingw-w64
  WITH_ONI=
fi

./configure --disable-maintainer-mode  \
            --prefix=${PREFIX} ${WITH_ONI}  \
            ${HOST}
make -j${CPU_COUNT}
make check
make install
