@echo off
setlocal enabledelayedexpansion
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ORMLite Table Config Utility Script for Windows
::
:: ORMLite on Android can be configured to use a table config
:: for performance reason.
::
:: Documentation:
:: http://ormlite.com/javadoc/ormlite-core/doc-files/ormlite_4.html#Config-Optimization
::
:: Table config file is created using OrmLiteConfigUtil class
:: and this batch file hopes to help with the automation of
:: this process.
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Configuration
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set to .\ if already in path
set JAVA_PATH=dev\java\jdk\bin
set ORMLITE_LIBS=dev\libs
set PROJECT_DIR=dev\android\projects

:: If needed, add additinal libraries here
:: Libraries are spearated by ;
set LIBS=.;%ORMLITE_LIBS%\*

:: Android resource directory
set RES_DIR=%PROJECT_DIR%\res

:: ORMLite config class and the location of all ORMLite table classes
set CONFIG_PACKAGE=com.project.data
set CONFIG_CLASS=DatabaseConfigUtil
set ORMLITE_CLASSES=%PROJECT_DIR%\src\com\project\data

:: ORMLite table config filename
set CONFIG_FILE=ormlite_config.txt

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

cd %ORMLITE_CLASSES%
set CLASSES=

:: Find classes annotated with @DatabaseTable
for %%F IN (*.java) do (
  for /f "tokens=* skip=2" %%P in ('find "@DatabaseTable" %%F') do (
    set CLASSES=!CLASSES! %%F
  )
)

:: Create raw dir required by OrmLiteConfigUtil
mkdir res\raw

:: Compile and execute
@%JAVA_PATH%\javac %* -d . -cp %LIBS% %CLASSES% %CONFIG_CLASS%.java
echo.
@%JAVA_PATH%\java -classpath %LIBS% %CONFIG_PACKAGE%.%CONFIG_CLASS%

echo.
echo.Ignore ClassNotFoundException for non table classes.

:: Create raw directory if it doesn't exit
if not exist %RES_DIR%\raw mkdir %RES_DIR%\raw

:: Copy config file to specified res dir
copy res\raw\%CONFIG_FILE% %RES_DIR%\raw\ >nul

:: Cleanup
rmdir /s/q com
rmdir /s/q res

endlocal
echo on

