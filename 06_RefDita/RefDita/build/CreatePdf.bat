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
    if "%COMPUTERNAME%"=="MUC1NS21283" goto seths
    set AXF_OPT=%ProgramData%\ezread\settings\AHFSettings.xml
    goto OptDone
    
:seths    
    set AXF_OPT=F:\Gnd\DocuDesign\Dita\AHF\settings\AHFSettings.xml
    
:OptDone    
    call mrp %ProjDoc% %DitaOutputDir%\ >trash
    set /p "ProjDocRel=" <trash
    del trash
    pushd .
    popd

    set DitaLogFile=logahf.txt
    if "%1"=="x" goto noAnt
    call ant %2 -f %BuildTarget%.ant -l %DitaLog%\%DitaLogFile% -DDitaOT=%Dita-OT% -DDitaOutputDir=%DitaOutputDir%  -DProjDocRel=%ProjDocRel% -DAXF_OPT=%AXF_OPT% -DINPUT=%Dita-Input% -DTOKEN=%Dita-Token% -DAHF_HOME=%AHF62_HOME%
    goto common

:noAnt
    @echo call ant %2 -f %BuildTarget%.ant -l %DitaLog%\%DitaLogFile% -DDitaOT=%Dita-OT% -DDitaOutputDir=%DitaOutputDir%  -DProjDocRel=%ProjDocRel% -DAXF_OPT=%AXF_OPT% -DINPUT=%Dita-Input% -DTOKEN=%Dita-Token% -DAHF_HOME=%AHF62_HOME%
    goto ende
:common
    call xcopy %DitaOutputDir%\%Dita-Input%.pdf ..\out\ /y
    call pdf
:ende
