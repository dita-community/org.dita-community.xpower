    @echo on
    if "%1"=="/?" goto helpit
    if "%1"=="" goto helpit
    
    set tmp2=%2
    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%tmp2%\%~n1.lnk');$s.TargetPath='%~f1';$s.Save()"
    set tmp2=
    goto ende

:helpit
    @echo Create Shortcut in target directory. Use as C:\work^>ShortCut  ^<sourcefile^>  ^<targetpath^>
    @echo ^.
    @echo e.g. ShortCut  C:\^>F:\hs\test.ext   C:\ProgramData\ezRead\ 
    goto ende
:ende    