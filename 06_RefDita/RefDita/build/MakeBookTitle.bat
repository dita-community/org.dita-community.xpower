    @echo off
    call SetInp.bat
    if "%1"=="" goto displayOnly

:newInput
rem ren ..\src\%Dita-Input%.ditamap %1.ditamap
    @echo call Set Dita-Input=%1>SetInp.bat
    call SetInp.bat

:displayOnly
    if "%Dita-Input"=="" goto notSpecified
    call set Dita-Input
    goto common

:notSpecified
    @echo Dita-Input=(not specified)

:common