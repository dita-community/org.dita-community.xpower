@echo off
%AHF62_HOME%\AHFCmd -x 2 -d "%DitaOutputDir%\topic.fo" -o "%DitaOutputDir%\topic.pdf" -i %AXF_OPT%
@echo %AXF_OPT%
call pdft