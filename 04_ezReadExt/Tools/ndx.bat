@echo off
call GetDrv %ProjDoc%
%ProjDrive%
call GetPathName %ProjDoc%
cd %ProjPathName%\dev\ref\ndx
cls
dir
