    @echo off    
rem Copy from wherever we are ... to %ProgramData%\Install because this is
rem a directory that allows users full r/w access without admin rights    
rem First we clean the install directory
    call rd %ProgramData%\Install /s /q
    call xcopy *.* /e /h /y                             %ProgramData%\Install\
    
rem Go to the install directory and install from there    
    %SystemDrive%
    cd %ProgramData%\Install
    
rem Copy to the specified directories, 
rem if you change the target, several batch files
rem and tools won't work anymore ...    
    call xcopy 00_InstallBatches\*.* /e /y /h           %ProgramData%\Install\
    call xcopy 04_ezReadExt\*.* /e /y /h                %ProgramData%\ezRead\
    
rem Remove the old DITA-OT, we will replace entirely    
    call rd %ProgramData%\Dita-OT2 /s /q
    call xcopy 05_Dita-OT2\*.* /e /y /h                 %ProgramData%\
    
rem Copy the Help system    
    call xcopy 06_RefDita\*.* /e /y /h                  %ProgramData%\Dita\
    
rem Install important environment variables (also in user registry !)    
    call 02_InstEnvE.bat
    cls
    dir

