#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./vendor/oniguruma
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

set -ex

chmod +x configure

./configure --prefix=$PREFIX --with-oniguruma=$PREFIX

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi

make install
