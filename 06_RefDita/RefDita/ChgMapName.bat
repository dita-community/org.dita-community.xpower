    @echo off
    if "%1"=="" goto noparm
    call r x
    call sb
    
    call regex "_([^_]*)_" %1 >newToken.txt
    set /P newtoken=<newToken.txt
    del newToken.txt
    
    @echo href=""%Dita-Token%/,href=""%newtoken%/ > repl.lst
    call replstr src\%Dita-Input%.ditamap repl.lst
    del repl.lst    
    type src\%Dita-Input%.RPL
    pause
    
    md attic
    call move src\%Dita-Input%.ditamap attic\
    ren src\%Dita-Input%.RPL %1.ditamap
    ren src\%Dita-Token% %newtoken%
    ren src\ditaval\%Dita-Token%.ditaval %newtoken%.ditaval
    call sb %newtoken%
    set %newtoken%=
    
goto ende

:noparm
    @echo No parameter given - enter new ditamap without the extension
    @echo e.g.
    @echo ChgMapName REF_newTitle_MyNewBook
    
:ende    
