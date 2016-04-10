    @echo ... 
	if exist "..\pdf\%Dita-Input%.pdf" goto showpdf
	call EditLogfile.bat
	goto ende

:showpdf	
    start ..\out\%Dita-Input%.pdf
	
:ende	
