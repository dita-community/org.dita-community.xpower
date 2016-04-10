    @echo off
    if "%1"=="java" goto setJava

rem Local test shall not install
    if "%USERNAME%"=="scherzer" goto ende

    md %ProgramData%\batch

rem Install the Help/References system
    pushd .
    cd 00_InstallBatches
    call batch\xc batch\*.* %ProgramData%\batch\
    call batch\xc References\*.* %ProgramData%\Dita\References\
    call batch\xc Settings\*.* %ProgramData%\Dita\Settings\
    call batch\xc Stylesheets\*.* %ProgramData%\Dita\Stylesheets\
    call batch\xc %ProgramData%\Dita\RefDita\build\book.ant %ProgramData%\Dita\Settings\
    call batch\addpath %Dita-OT%%\bin
    call batch\addpath %ProgramData%\batch
    call batch\addpath %ProgramData%\ezRead\Tools
    popd

rem Install ezRead - you might need admin rights to copy ND.API to
rem %ProgramFiles(x86)%\Adobe\Acrobat 11.0\Acrobat\plug_ins\ or wherever
rem your Acrobat installation is. InstNde.exe detects the Acrobat directory
rem but as this is typically under %ProgramFiles(x86)%, for non-admin users
rem the ND.API plugin (ezRead) cannot be copied there. Read [ezRead#1.1]
rem to learn about the installation
    pushd .
    cd   %ProgramData%\ezRead\AdobePlugIn\
    call 01_InstNd.EXE
    call 02_AutoHotkey_L_Install
    call 03_Ahk.bat
    start Basic.ahk
    start SkipAdobeSecPrompt.ahk
    call 04_InstNet.bat
    call UseEzRead.bat
    popd

rem Set the environment variables in user registry
    set DITA-OT=%ProgramData%\Dita-OT2
    set ProjDoc=%ProgramData%\ezRead\Documentation
    set /P ezserno=<%ProgramData%\ezRead\AdobePlugin\SerialNo.txt
    reg ADD HKCU\NDplugin    /v SerialNo /t REG_SZ /d %ezserno% /f
    set ezserno=

    reg ADD HKCU\Environment /v Dita-OT  /t REG_SZ /d %Dita-OT% /f
    reg ADD HKCU\Environment /v Dita-CFG /t REG_SZ /d %ProgramData%\Dita /f
    reg ADD HKCU\Environment /v ANT_HOME /t REG_EXPAND_SZ /d %Dita-OT% /f
    reg ADD HKCU\Environment /v ANT_OPTS /t REG_SZ /d "-Xmx1024m -Xms1024m" /f
    reg ADD HKCU\Environment /v AXF_OPT /t REG_EXPAND_SZ /d %ProgramData%\Dita\settings\AHFSettings.xml /f
    reg ADD HKCU\Environment /v CLASSPATH /t REG_EXPAND_SZ /d %Dita-OT%\lib\xslthl-2.1.3.jar;%Dita-OT%\lib\saxon.jar;%Dita-OT%\lib\saxon-dom.jar;%Dita-OT%\lib\xercesImpl.jar;%Dita-OT%\lib\xml-apis.jar; /f
    reg ADD HKCU\Environment /v ProjDoc /t REG_EXPAND_SZ /d %ProgramData%\ezRead\Documentation /f

    @echo[
    @echo[
    @echo The above installations should have worked correctly
    @echo unless some installations require admin rights (which you might not have)
    @echo Installations which require admin rights are:
    @echo[
    @echo    InstNd.exe     - copy ezread ND.API into the Acrobat plugins directory
    @echo    Autohotkey.exe - installs F12 hotkeys to work easily with the ezRead system
    @echo[
    pause
    cls
    @echo[
    java -version
    @echo[
    @echo[
    @echo The following settings might already be present, check whether you can do "java -version"
    @echo if you cannot execute java ... you might invoke this 02_InstEnvE.bat with
    @echo 02_InstEnvE java
    @echo but be careful to put the right path to your actual Java installation
    goto ende

:setJava
    reg ADD HKCU\Environment /v JAVA_HOME /t REG_EXPAND_SZ /d %ProgramFiles(x86)%\Java\jre7 /f
    reg ADD HKCU\Environment /v JAVA_HOME /t REG_EXPAND_SZ /d %ProgramFiles%\Java\jdk1.7.0_25 /f
    call addpath "%JAVA_HOME%\bin

:ende
