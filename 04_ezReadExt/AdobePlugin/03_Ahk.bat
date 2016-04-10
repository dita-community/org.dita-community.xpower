    @echo off
    if "%COMPUTERNAME%"=="MUC1NS21283" goto ende
    call ..\tools\shortcut Basic.ahk              "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
    call ..\tools\shortcut SkipAdobeSecPrompt.ahk "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
:ende    