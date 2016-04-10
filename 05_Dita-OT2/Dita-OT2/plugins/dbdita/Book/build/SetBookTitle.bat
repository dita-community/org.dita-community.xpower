    @echo off
    if "%1"=="" goto displayOnly
    if "%Dita-Input%"=="" goto newInput
rem @echo Dita-Input already set to %Dita-Input%
:newInput
    @echo call Set Dita-Input=%1>SetInp.bat
    call SetInp.bat
    ren ..\src\*.ditamap %1.ditamap

:displayOnly
    if "%Dita-Input"=="" goto notSpecified
    call set Dita-Input
    goto common

:notSpecified
    @echo Dita-Input=(not specified)

:common