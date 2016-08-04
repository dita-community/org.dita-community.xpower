rem This file copies the current book into another book. This is useful
rem for e.g. meeting reports which often have the same layout
rem
rem Syntax: CpyMapName NEW_newtoken_newtext
rem
rem         will create the NEW_newtoken_newtext.ditamap and all
rem         necessary files (incl. the .ditaval) to obtain a
rem         running copy.
    @echo off
    if "%~dpn1"=="" goto noparm
    call r x
    call sb

    call regex "_([^_]*)_" %~dpn1 >newToken.txt
    set newtoken=
    set /P newtoken=<newToken.txt
    if "%newtoken%"=="" goto nomap
    del newToken.txt

    @echo href=""%Dita-Token%/,href=""%newtoken%/ > repl.lst
    call replstr src\%Dita-Input%.ditamap repl.lst
    del repl.lst
    @echo F>F
    del src\%~dpn1.ditamap
    call ren src\%Dita-Input%.RPL %~dpn1.ditamap
    call xcopy src\%Dita-Token%\* src\%newtoken%\
    call xcopy src\ditaval\%Dita-Token%.ditaval src\ditaval\%newtoken%.ditaval<F
    del F
    call sb %newtoken%
    set newtoken=
    goto ende

:nomap
    @echo[
    @echo ERROR: The new file must have a _token_ layout e.g. REF_mydoc_mydocExample
    @echo[
    @echo e.g. CpyMapName REF_newTitle_MyNewBook
    goto ende

:noparm
    @echo No parameter given - enter new ditamap without the extension
    @echo e.g.
    @echo CpyMapName REF_newTitle_MyNewBook

:ende
