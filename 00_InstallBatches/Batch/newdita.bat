    @echo off
    if "%1"=="" goto copysrc
    if "%1"=="full" goto copyfull
    goto nocopy
    
:copyfull
    call xc %ProgramData%\Dita\RefDita\*.* Book\ /EXCLUDE:%ProgramData%\Dita\RefDita\nocopy.txt
    if "%2"=="" goto common
    call ChgMapName %1
    goto common
    
:copysrc    
    call xc %ProgramData%\Dita\RefDita\src\*.* Book\src\
    call xc %ProgramData%\Dita\RefDita\build\*.* Book\build\
    if "%1"=="" goto common
    call ChgMapName %1
    goto common

:nocopy    
    goto copysrc
    
:common
    call sb book
    goto ende
    cls
    dir    
:ende    
