if (!(Test-path "c:\LedCameras\.git")) {
    cd "c:\ledcameras"
    git init
    git remote add origin git@github.com:TestRepository.git
}

if ((Get-WMIObject -Class Win32_Process -Filter "Name='PowerShell.EXE'" | where { $_.commandline -like "*ledcameras_api*" }) -ne $null) {
    $processStartDate = Get-WMIObject -Class Win32_Process -Filter "Name='PowerShell.EXE'" | where { $_.commandline -like "*ledcameras_api*" }`
    | % { $_.ConvertToDateTime( $_.CreationDate ) } | Get-Date -format "dd/MM/yyyy HH:mm"
    $processID = (Get-WMIObject -Class Win32_Process -Filter "Name='PowerShell.EXE'" | where { $_.commandline -like "*ledcameras_api*" }).ProcessID
    $nowDate = Get-Date -format "dd/MM/yyyy HH:mm"
    $minutes = (New-TimeSpan -Start $processStartDate -End $nowDate).TotalMinutes

    if($minutes -gt 30) {
        Stop-Process -Id $processID -Force
        $arg = "& c:\LedCameras\LEDCameras_API.bat"
        Start-Process PowerShell.exe -ArgumentList $arg -WindowStyle Minimized
    }
    else {
        Write-Host "OK"
    }
}
else {
    sleep -s 10
    
    if ((Get-WMIObject -Class Win32_Process -Filter "Name='PowerShell.EXE'" | where { $_.commandline -like "*ledcameras_api*" }) -ne $null) {
        Write-Host "OK"
    }
    else {
        $arg = "& c:\LedCameras\LEDCameras_API.bat"
        Start-Process PowerShell.exe -ArgumentList $arg -WindowStyle Minimized
    }
}