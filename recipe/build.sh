#!/bin/bash

set -ex

chmod +x configure

[[ "$target_platform" == "win-64" ]] && export CFLAGS="$CFLAGS -Disatty=_isatty -DWIN32 -DYY_NO_UNISTD_H -include io.h" && cd $(pwd)
./configure --prefix=$PREFIX --with-oniguruma=$PREFIX
[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check
fi
make install
