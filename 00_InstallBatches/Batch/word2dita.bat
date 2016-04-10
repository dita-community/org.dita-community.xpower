    @echo off
    if "%1"=="" goto noInput
    if "%Dita-Settings%"=="" goto setStyle
    goto proc

:noInput
    @echo You shall enter the input file e.g. "test.docx" ...
    @echo Process aborted !
    goto ende

:setStyle
    set Dita-Settings="%Dita-CFG%\settings"

:proc

    call ant -l logahf.txt -f %Dita-OT%\plugins\org.dita4publishers.word2dita\build-word2dita.xml "-Dw2d.style-to-tag-map=%Dita-Settings%/style2tagmap.xml" "-Dw2d.out.dir=%CD%\src" "-DmediaDirUri=%CD%\src\gfx" "-Dw2d.temp.dir=%CD%/temp/" "-Dword.doc=%CD%\%1"

    call e logahf.txt

:ende