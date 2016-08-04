rem This file renames the current book into another book. This is useful
rem if you need to change the .ditamap's title
rem
rem Syntax: ChgMapName NEW_newtoken_newtext
rem
rem         will rename the current book to the NEW_newtoken_newtext.ditamap
rem         and also renames necessary files (incl. the .ditaval) and the
rem         ditamap's directory references.
    @echo off
    if "%1"=="" goto noparm
    call r x
    call sb

    call regex "_([^_]*)_" %1 >newToken.txt
    set newtoken=
    set /P newtoken=<newToken.txt
    if "%newtoken%"=="" goto nomap
    del newToken.txt

    @echo href=""%Dita-Token%/,href=""%newtoken%/ > repl.lst
    call replstr src\%Dita-Input%.ditamap repl.lst
    del repl.lst    
    
    md attic
    call move src\%Dita-Input%.ditamap attic\
    ren src\%Dita-Input%.RPL %1.ditamap
    ren src\%Dita-Token% %newtoken%
    ren src\ditaval\%Dita-Token%.ditaval %newtoken%.ditaval
    call sb %newtoken%
    set newtoken=
    goto ende

:nomap
    @echo[
    @echo ERROR: The new file must have a _token_ layout e.g. REF_mydoc_mydocExample
    @echo[
    @echo e.g. ChgMapName REF_newTitle_MyNewBook
    goto ende

:noparm
    @echo No parameter given - enter new ditamap without the extension
    @echo e.g.
    @echo ChgMapName REF_newTitle_MyNewBook

:ende
