@echo off
pushd .
cd build
call ProcessTopicFo.bat %1 %2 %3 %4
popd
