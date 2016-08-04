    @echo[
	if exist "..\out\%Dita-Input%.pdf" goto showpdf
	@echo %Dita-Input%.pdf does not exist
	goto ende

:showpdf	
    start ..\out\%Dita-Input%.pdf
	
:ende	
