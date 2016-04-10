    @echo off
rem Consider mrp=makerelpath for final delivery	
    
    call SetInp.bat
    set BuildTarget=book
    set DitaLog=log
    set DitaOutputDir=..\pdf
    if "%AXF_OPT%"=="" goto setOpt
    goto OptDone
    
:setOpt    
    if "%COMPUTERNAME%"=="HSCHERZER" goto seths
    set AXF_OPT=%ProgramData%\ezread\settings\AHFSettings.xml
    goto OptDone
    
:seths    
    set AXF_OPT=F:\Gnd\DocuDesign\Dita\AHF\settings\AHFSettings.xml
    
:OptDone    
    call mrp %ProjDoc% %DitaOutputDir%\ >trash
    set /p "ProjDocRel=" <trash
    del trash
    pushd .
    cd ..\src\gfx
    set ProjGfx="%CD%"
    popd

    set DitaLogFile=logahf.txt
    if "%1"=="x" goto noAnt
    call ant %2 -f %BuildTarget%.ant -l %DitaLog%\%DitaLogFile% -DDitaOT=%Dita-OT% -DDitaOutputDir=%DitaOutputDir%  -DProjDocRel=%ProjDocRel% -DAXF_OPT=%AXF_OPT% -DINPUT=%Dita-Input% -DAHF_HOME=%AHF62_HOME% -DgfxPath=%ProjGfx%
    goto common

:noAnt
    @echo call ant %2 -f %BuildTarget%.ant -l %DitaLog%\%DitaLogFile% -DDitaOT=%Dita-OT% -DDitaOutputDir=%DitaOutputDir%  -DProjDocRel=%ProjDocRel% -DAXF_OPT=%AXF_OPT% -DINPUT=%Dita-Input% -DAHF_HOME=%AHF62_HOME% -DgfxPath=%ProjGfx%
    goto ende
:common
    call pdf
:ende
