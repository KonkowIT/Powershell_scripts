$TimeSpanInterval = New-TimeSpan -Minutes 5
$action = New-ScheduledTaskAction -Execute 'C:\SCREENNETWORK\admin\hideUpdates.bat'
$trigger = New-ScheduledTaskTrigger -At 00:00:01 -RepetitionInterval $TimeSpanInterval -Once
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$taskName = "HideWU"

$HideWU = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Description "Ukrywanie aktualizacji"

Register-ScheduledTask -TaskName $taskName -InputObject $HideWU -ea SilentlyContinue -Force;
Start-ScheduledTask -TaskName $taskName -ea SilentlyContinue;

Remove-item 'HideWU_taskCreator.ps1' -Force
Remove-item 'HideWU_taskCreator.bat' -Force