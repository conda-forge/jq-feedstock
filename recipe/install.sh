#!/bin/bash
set -ex

autoreconf \
    --install \
    --force \
    --verbose

./configure \
    --disable-maintainer-mode \
    --prefix="${PREFIX}" \
    --with-oniguruma="${PREFIX}" \
    CFLAGS="-Wno-implicit-function-declaration" \
    "${HOST}"

make -j${CPU_COUNT}
[[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]] && make check
make install
