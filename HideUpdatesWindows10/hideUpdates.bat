@echo off
set logfile=C:\HideWindowsUpdatesLOG.txt
echo %date% - %time% >> %logfile%
powershell -executionpolicy bypass -command "&C:\SCREENNETWORK\admin\hideUpdates.ps1" >> %logfile%
echo[ >> %logfile%
echo[ >> %logfile%