@echo off

setlocal EnableDelayedExpansion

REM Set MSYS2 environment
set MSYSTEM=MINGW64
set MSYS2_ARG_CONV_EXCL="*"

REM Configure and build jq for Windows using m2w64 tools

REM Run configure with Windows-specific options using bash
bash -c "./configure --prefix=%LIBRARY_PREFIX:\=/% --with-oniguruma=%LIBRARY_PREFIX:\=/% --host=x86_64-w64-mingw32 --target=win64-x86_64"

REM Build using make from m2-make with CPU_COUNT cores
make -j%CPU_COUNT%

REM Skip tests during cross-compilation (similar to Linux version)
if not "%CONDA_BUILD_CROSS_COMPILATION%"=="1" (
    make check
)

REM Install to the prefix
make install

endlocal
