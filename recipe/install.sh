#!/bin/bash
set -e

autoreconf \
    --install \
    --force \
    --verbose

# if [[ $(uname) =~ M.* ]]; then
#     HOST=--host=x86_64-w64-mingw32
#     pushd modules/oniguruma
#         autoreconf -vfi
#     popd
#     PREFIX=${PREFIX}/Library/mingw-w64
# fi

./configure \
    --disable-maintainer-mode \
    --prefix="${PREFIX}" \
    --with-oniguruma="${PREFIX}" \
    CFLAGS="-Wno-implicit-function-declaration" \
    "${HOST}"

make -j${CPU_COUNT}
[[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]] && make check
make install
