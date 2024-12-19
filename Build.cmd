@echo off

:Main
setlocal
setlocal enableextensions
setlocal enabledelayedexpansion
set "JAVA_TOOL_OPTIONS=%JAVA_TOOL_OPTIONS% -Duser.language=en-US"
for /d %%a in ("%ProgramFiles%\Eclipse Adoptium\jdk-11.*-hotspot") do (
	set "JAVA_HOME=%%~a"
	set      "PATH=!JAVA_HOME!\bin;!PATH!"
)
set "Cycle=Z"
set "Stage=100"
pushd "%~dp0"
if exist "Clean.cmd" (
	call Clean.cmd .
)
REM Detect errors only
call :Cycle A
REM Report all warnings
call :Cycle B
REM Treat warnings as errors
call :Cycle C
call :Cycle D
if exist "?_??_*.log" (
	findstr /n /b /c:"[WARNING]" "?_??_*.log" >"_warnings.log"
	findstr /n /b /c:"[ERROR]"   "?_??_*.log" >"_errors.log"
)
popd
endlocal
if "%~1"=="" (pause)
goto :EOF

:Cycle
if "%~1"=="" (goto :EOF)
set "Cycle=%~1"
set "Stage=100"
if "%~1"=="A" (
	set "compiler.xlintarg=-Dcompiler.xlintarg=-Xlint:none"
	set "compiler.warg="
) else (
	if "%~1"=="B" (
		set "compiler.xlintarg=-Dcompiler.xlintarg=-Xlint:all,-processing"
		set "compiler.warg="
	) else (
		set "compiler.xlintarg=-Dcompiler.xlintarg=-Xlint:all,-processing"
		set "compiler.warg=-Dcompiler.warg=-Werror"
	)
)
call :Maven "clean.log" "clean"
if "%~1"=="A" (
	call :Maven "pom.log"     "-Doutput=pom.effective.xml -Dverbose=false help:effective-pom"
	call :Maven "tree.log"    "dependency:tree"
	call :Maven "plugins.log" "versions:display-plugin-updates"
	call :Maven "updates.log" "versions:display-dependency-updates"
)
if "%~1"=="D" (
	REM call :Maven "rewrite.log" "rewrite:run"
)
call :Maven "compile.log" "!compiler.xlintarg! !compiler.warg! compile"
call :Maven "test.log"    "!compiler.xlintarg! !compiler.warg! test"
if "%~1"=="D" (
	call :Maven "verify.log" "!compiler.xlintarg! !compiler.warg! verify"
	REM call :Maven "report.log" "-nsu site"
	REM call :Maven "stage.log"  "-DstagingDirectory=%CD%\reports site:stage"
	if exist "distribution.xml" (
		call :Maven "package.log" "package"
	) else (
		REM call :Maven "install.log" "install"
	)
)
goto :EOF

:Maven
if "%~1"=="" (goto :EOF)
if !ErrorLevel! NEQ 0 (goto :EOF)
set /a "Stage+=1"
if not "%~2"=="" (
	call :Try call mvn -l "!Cycle!_!Stage:~1!_%~nx1" %~2
) else (
	call :Try call mvn --quiet %~1
)
goto :EOF

:Try
echo %*
echo.
%*
echo.
goto :EOF

:EOF