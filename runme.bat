@echo off
setlocal
CALL :GETPARENT PARENT
IF /I "%PARENT%" == "powershell" GOTO :ISPOWERSHELL
IF /I "%PARENT%" == "pwsh" GOTO :ISPOWERSHELL
endlocal

echo Not running from Powershell 
call .\venv\Scripts\Activate.bat
python .\app_rvc.py --theme Respair/Shiki@1.2.1

GOTO :EOF

:GETPARENT
SET "PSCMD=$ppid=$pid;while($i++ -lt 3 -and ($ppid=(Get-CimInstance Win32_Process -Filter ('ProcessID='+$ppid)).ParentProcessId)) {}; (Get-Process -EA Ignore -ID $ppid).Name"

for /f "tokens=*" %%i in ('powershell -noprofile -command "%PSCMD%"') do SET %1=%%i

GOTO :EOF

:ISPOWERSHELL
echo. >&2
echo ERROR: This batch file must not be run from a PowerShell prompt... Initiating CMD Shell >&2
echo. >&2
echo Please execute runme.bat again :)
echo. >&2
cmd
exit /b 1
