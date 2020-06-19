#checking administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = ( -join ("& ", $myinvocation.mycommand.definition))
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Stop-Process $PID
} 

#logfile
$logFile = "C:\HideWindowsUpdatesLOG.txt"
if (!(Test-Path -Path $logFile)) {
    New-Item -Path C:\ -Name HideWindowsUpdatesLOG.txt -ItemType File | Out-Null
}

#instalacja nuget package provider
get-PackageProvider -Name NuGet -ea SilentlyContinue -Force -ForceBootstrap | Out-Null

#instalacja pakietu PSWU
if ($null -eq (Get-InstalledModule pswindowsupdate -ea SilentlyContinue)) {
    Write-output "Instalowanie pakietu PSWindowsUpdate..."
    install-Module pswindowsupdate -force
}

#dodanie WU
if ($null -eq (Get-WUServiceManager | Where-Object { $_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d" })) {
    Write-output "Adding Microsoft Update..."
    Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7 -Confirm:$false
}

#skrypt
$listWU = get-wulist
if ($null -eq $listWU) {
    "No available updates"
    "`n"
}
else {
    $listKBs = $listWU | Select-Object -Property KB
    foreach ($oneKB in $listKBs) {
        "Hideing " + $oneKB.KB
        Hide-WindowsUpdate -KBArticleID $oneKB.KB -Hide -confirm:$false -Verbose | out-null 
    }

    if ($null -eq (get-wulist)) {
        Write-output "Updates are hidden"
    }
    "`n"
}
