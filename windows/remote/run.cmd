@echo off

set host=hostname
set user=root
set pwd=test
set port=22

:params
if "%~1"=="" goto vnc
if "%~1"=="/r" goto rdp
if "%~1"=="/v" goto vnc

:rdp
set cmdline=plink.exe -P %port% -R 0.0.0.0:19999:localhost:3389 -N %user%@%host% -pw %pwd%

:reload
echo Restarting connection
start %cmdline%

:monitor
rem pause imitation
ping -n 10 127.0.0.1 > nul
set plink=""
for /f "delims= " %%a in ('tasklist ^| findstr /i "plink"') do set plink=%%a
rem if plink is not running, reload it
echo (%plink%)
if (%plink%)==() goto reload
if (%plink%)==("") goto reload
goto monitor

rem ****************************************************************************
rem VNC
rem ****************************************************************************

:vnc
set cmdlinevnc=plink.exe -P %port% -R 0.0.0.0:19999:localhost:5900 -N %user%@%host% -pw %pwd%
netsh firewall add portopening tcp 5900 vnc > nul
taskkill /im winvnc.exe /f > nul
taskkill /im plink.exe /f > nul
start winvnc.exe
ping -n 5 127.0.0.1 > nul

:reloadvnc
echo Restarting connection
start %cmdlinevnc%

:monitorvnc
rem pause imitation
ping -n 10 127.0.0.1 > nul
set plink=""
for /f "delims= " %%a in ('tasklist ^| findstr /i "plink"') do set plink=%%a
rem if plink is not running, reload it
rem echo (%plink%)
if (%plink%)==() goto reloadvnc
if (%plink%)==("") goto reloadvnc

set wvnc=""
for /f "delims= " %%a in ('tasklist ^| findstr /i "winvnc"') do set wvnc=%%a
if (%wvnc%)==() goto vnc
if (%wvnc%)==("") goto vnc

goto monitorvnc

