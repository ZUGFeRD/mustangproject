@echo off

:Main
setlocal
setlocal enableextensions
setlocal enabledelayedexpansion
pushd "%~dp0"
call :CleanUp
popd
endlocal
if "%~1"=="" (pause)
goto :EOF

:CleanUp
if exist "*.log" (
	del /f /q "*.log"
)
if exist "pom.effective.xml" (
	del /f /q "pom.effective.xml"
)
del /f /q /s "dependency-reduced-pom.xml" 1>nul 2>&1
for /d %%a in ( *reports ) do (
	rd /s /q "%%~a"
)
for /r /d %%a in ( *target ) do (
	rd /s /q "%%~a"
)
if exist "%USERPROFILE%\.fop\fop-fonts.cache" (
	del /f /q "%USERPROFILE%\.fop\fop-fonts.cache"
)
goto :EOF

:Try
echo %*
echo.
%*
echo.
goto :EOF

:EOF
