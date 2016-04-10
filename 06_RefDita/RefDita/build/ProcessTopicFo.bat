    @echo off
    if "%1"=="" goto prcdita
    
:prcfile
    cd %DitaOutputDir%
    set DitaOutputPath=%CD%
    cd ..
    %AHF62_HOME%\AHFCmd -x 2 -d "%1" -o "%DitaOutputPath%\topic.pdf" -i %AXF_OPT%
    @echo %AXF_OPT%
    start %DitaOutputPath%\topic.pdf
    goto ends
    
:prcdita    
    call SetTemp.bat
    pushd .
    cd %DitaOutputDir%
    set DitaOutputPath=%CD%
    cd %tempdir%
    %AHF62_HOME%\AHFCmd -x 2 -d "topic.fo" -o "%DitaOutputPath%\topic.pdf" -i %AXF_OPT%
    @echo %AXF_OPT%
    popd
    call pdft
    goto ends
    
    
:ends    

