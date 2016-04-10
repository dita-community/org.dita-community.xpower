    @echo off
    if "%1"=="" goto displayOnly
    
    dir /B ..\src\*_%~n1_* >mapfile.txt
    set tmpchk=DEFAULT
    set /P tmpchk=<mapfile.txt
    if "%tmpchk%"=="DEFAULT" goto err01
    
    call GetFilename.bat %tmpchk%
    set /P Dita-Input=<mapfile.txt
    set Dita-Token=%~n1
    @echo call Set Dita-Input=%Dita-Input%>SetInp.bat
    @echo call Set Dita-Token=%Dita-Token%>>SetInp.bat
    goto ende
    
:err01  
    cls
    @echo %~n1% does not exist
    goto enderr
    
:ende
    del mapfile.txt
    set tempchk=
    
:displayOnly    
    cls 
    call SetInp.bat

:enderr 
    set Dita-Input
    set Dita-Token
    echo.
    echo.
    for /f %%f in ('dir /b ..\src\*_*_*') do (
       call regex "_([^_]*)_" %%f 
       echo(
    )
