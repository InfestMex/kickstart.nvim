@echo off
setlocal

:: This script should be placed in C:\DEV_HOME\CMX
set "BASE_DIR=C:\DEV_HOME\CMX\"
set "WS_CEN_DIR=%BASE_DIR%ws-cen"
set "GIT_DIR=%WS_CEN_DIR%\git"
set "METADATA_DIR=%WS_CEN_DIR%\.metadata\.plugins\org.eclipse.wst.server.core"
set SHARED_HOME=C:/DEV_HOME
set JAVA_HOME=%SHARED_HOME%/TOOLS/java/21.0.6

:: ------------- DEPLOYMENTS -----------------
echo Starting server WAR deployments...
echo.

call :deploy_war "cis-war"      "ses\build\cis\cis-war"      "tmp0"
call :deploy_war "sdc-war"      "ses\build\sdc\sdc-war"      "tmp1"
call :deploy_war "pos-server-war" "pos-server\build\pos-server\pos-server-war" "tmp5"
call :deploy_war "cps-war"      "cps\build\cps\cps-war"      "tmp3"
call :deploy_war "ucon-war"      "ses\build\ucon\ucon-war"      "tmp6"
call :deploy_war "launchpad-war" "launchpad\build\launchpad\launchpad-war" "tmp7"

echo.
echo All deployments finished.
pause
goto :eof

:: --------------------------------------------------------------------
:: Reusable deployment function
:: Param 1: WAR name (e.g., "cis-war")
:: Param 2: Project path relative to git dir (e.g., "ses\build\cis\cis-war")
:: Param 3: Eclipse temp dir name (e.g., "tmp0")
:deploy_war
    set "_war_name=%~1"
    set "_project_path=%~2"
    set "_tmp_dir=%~3"

    echo ----------------------------------------
    echo Deploying %_war_name%
    echo ----------------------------------------

    set "WAR_SOURCE_DIR=%GIT_DIR%\%_project_path%\target"
    set "DEST_FOLDER=%METADATA_DIR%\%_tmp_dir%\wtpwebapps\%_war_name%"

    echo. 
    echo Source: %WAR_SOURCE_DIR%
    echo Destination: %DEST_FOLDER%
    echo.

    echo Searching for %_war_name% file...
    set "WAR_FILE_NAME="
    for /f "tokens=* delims=" %%i in ('dir /b /od "%WAR_SOURCE_DIR%\%_war_name%-*.war" 2^>nul') do (
        set "WAR_FILE_NAME=%%i"
    )

    if not defined WAR_FILE_NAME (
        echo ERROR: No .war file found for %_war_name% in the source directory.
        goto :eof
    )

    set "WAR_FILE=%WAR_SOURCE_DIR%\%WAR_FILE_NAME%"
    echo Found WAR file: %WAR_FILE%

    echo Cleaning destination folder...
    if exist "%DEST_FOLDER%\" (
        rd /s /q "%DEST_FOLDER%"
    )
    md "%DEST_FOLDER%"

    echo Deploying content...
    cd /d "%DEST_FOLDER%"
    %JAVA_HOME%\bin\jar xf "%WAR_FILE%"

    echo %_war_name% deployment finished.
    echo.
    goto :eof
:: --------------------------------------------------------------------
