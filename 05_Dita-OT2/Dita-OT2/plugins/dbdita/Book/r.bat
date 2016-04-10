@echo off
pushd .
cd build
call CreatePdf.bat %1 %2 %3 %4 %5 %6
popd