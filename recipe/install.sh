#!/bin/bash
set -ex

ONIGURUMA="${PREFIX}"
if [[ $(uname) =~ MSYS.* ]]; then
    PREFIX="$(cygpath "${PREFIX}")"
    CFLAGS="-I${PREFIX}/Library/mingw-w64/x86_64-w64-mingw32/include"
    ONIGURUMA="${PREFIX}/Library"
fi

grep -r OnigEncodingUTF8 "${ONIGURUMA}"
grep -r OnigSyntaxPerl_NG "${ONIGURUMA}"

./configure \
    --disable-docs \
    --disable-valgrind \
    --disable-maintainer-mode \
    --prefix="${PREFIX}" \
    --with-oniguruma="${ONIGURUMA}" \
    CFLAGS="${CFLAGS}"


make -j${CPU_COUNT}
[[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]] && make check VERBOSE=yes
make install
