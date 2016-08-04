    @echo off
    call SetTemp.bat
    call %tempdir%\topic.fo
    call ue %tempdir%\topic.fo  %1 %2 %3 %4 %5

