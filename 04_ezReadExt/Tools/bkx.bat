@echo off
call GetDrv %ProjDoc%
%ProjDrive%
call GetPathName %ProjDoc%
cd %ProjPathName%\dev\ref\bkx
cls
dir
