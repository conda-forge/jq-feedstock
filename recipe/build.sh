#!/bin/bash

set -x

chmod +x configure

./configure --disable-maintainer-mode --prefix=$PREFIX --with-oniguruma=$PREFIX
[[ "$target_platform" == "win-64" ]] && patch_libtool && sed -e 's/"/\\"/g' -e 's/^/"/' -e 's/$$/\\n"/' src/builtin.jq > src/builtin.inc

make -j${CPU_COUNT}
make check
make install
