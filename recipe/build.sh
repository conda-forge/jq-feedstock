#!/bin/bash

set -ex

chmod +x configure

if [[ "$build_platform" == "win-64" ]]; then
    # Fix `src/lexer.c:839:10: fatal error: 'unistd.h' file not found`, `src/lexer.h:474:10: fatal error: 'unistd.h' file not found`
    export CFLAGS="$CFLAGS -DYY_NO_UNISTD_H"
    # Fix `src/lexer.c:2041:40: error: call to undeclared function 'isatty'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]`
    # https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/posix-isatty?view=msvc-170
    # https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/isatty?view=msvc-170
    export CFLAGS="$CFLAGS -include io.h"
    # `src/main.c:4:10: fatal error: 'libgen.h' file not found`
    # `src/builtin.c:11:10: fatal error: 'sys/time.h' file not found`
    export CFLAGS="$CFLAGS -DWIN32"
    # Fix `configure: error: unsafe absolute working directory name`
    cd $(pwd)
fi
./configure --prefix=$PREFIX --with-oniguruma=$PREFIX
[[ "$build_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check
fi
make install
