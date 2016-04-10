@echo off
call GetDrv %ProjDoc%
%ProjDrive%
call GetPathName %ProjDoc%
cd %ProjPathName%\dev\export
cls
dir books
