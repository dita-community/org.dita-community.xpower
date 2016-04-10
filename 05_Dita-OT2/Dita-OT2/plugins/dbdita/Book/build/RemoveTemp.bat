@echo off
call CreatePdf x
call rd temp /s /q
call rd %Ditaoutputdir%\Customization /s /q
call rd %Ditaoutputdir%\Configuration /s /q
call rd %Ditaoutputdir%\gfx /s /q
cls
dir