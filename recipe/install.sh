#!/bin/bash
set -ex

if [[ $(uname) =~ MSYS.* ]]; then
    PREFIX="$(cygpath "${PREFIX}")"
    CFLAGS="-I${PREFIX}/Library/mingw-w64/x86_64-w64-mingw32/include"
    ONIGURUMA="${PREFIX}/Library"
fi

echo ./configure \
    --disable-docs \
    --disable-valgrind \
    --disable-maintainer-mode \
    --prefix="${PREFIX}" \
    --with-oniguruma="${ONIGURUMA}" \
    CFLAGS="${CFLAGS}"

./configure \
    --disable-docs \
    --disable-valgrind \
    --disable-maintainer-mode \
    --prefix="${PREFIX}" \
    --with-oniguruma="${ONIGURUMA}" \
    CFLAGS="${CFLAGS}"


if ! make -j${CPU_COUNT}; then
    cat Makefile
fi
[[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]] && make check VERBOSE=yes
make install
