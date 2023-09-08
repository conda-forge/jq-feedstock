#!/bin/bash
set -ex

if [[ $(uname) =~ MSYS.* ]]; then
    CFLAGS="-I${LIBRARY_PREFIX}/mingw-w64/x86_64-w64-mingw32/include/"
fi

./configure \
    --disable-docs \
    --disable-valgrind \
    --disable-maintainer-mode \
    --prefix="${PREFIX}" \
    --with-oniguruma=${LIBRARY_PREFIX:-${PREFIX}} \
    CFLAGS="${CFLAGS}"


make -j${CPU_COUNT}
[[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]] && make check VERBOSE=yes
make install
