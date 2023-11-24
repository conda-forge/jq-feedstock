#!/bin/bash

set -ex

if [[ "$target_platform" != "win-64" ]]; then
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./modules/oniguruma
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config
fi

chmod +x configure

./configure --prefix=$PREFIX --with-oniguruma=$PREFIX
[[ "$target_platform" == "win-64" ]] && patch_libtool && sed -e 's/"/\\"/g' -e 's/^/"/' -e 's/$$/\\n"/' src/builtin.jq > src/builtin.inc

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi

make install
