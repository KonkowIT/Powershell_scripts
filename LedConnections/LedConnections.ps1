$PathSNJson = "C:\LedConnections\data_export.json"
$csvPrem = "C:\Metadane_do_skryptow\meta_premium.csv"
$csvCity = "C:\Metadane_do_skryptow\meta_city.csv"
$csvSupe = "C:\Metadane_do_skryptow\meta_super.csv"
$csvPT = "C:\Metadane_do_skryptow\meta_pakiet.csv"

if (Test-Path $PathSNJson) {
    $servers = Get-Content -Raw -Path $PathSNJson | ConvertFrom-Json
}
else {
    Write-Host "Bledna sciezka do pliku .json!" -ForegroundColor Red -BackgroundColor Black 
    Break
}

# MD5
$scriptMD5 = (Get-FileHash -Path $myinvocation.mycommand.definition -Algorithm MD5).hash

# qty
$qtyServers = ($servers | Measure-Object).Count - 1

# lista nieaktywnych ekranow 
$excludedList = @(
    # testowe
    "sn086", `
    "sn1057", `
    "sn1251", `
    "sn2023", `
    # testowy Pl. Unii
    "sn2035", `
    # testowy Marriott
    "sn2039", `
    # testowy Corner
    "sn2101"
)

gc "C:\Metadane_do_skryptow\sn_disabled.txt" -ErrorAction SilentlyContinue | % { 
    if ($excludedList -notcontains $_) {
        $excludedList = [array]$excludedList + $_
    }
}

# Script start date
$startDate = get-date -DisplayHint date -Format MM/dd/yyyy

#Server SN
$serverSN = "1.1.1.1"

# functions
function Start-SleepTimer($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while ($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -activity "LED connections" -Status "Nastepne sprawdzenie polaczen za" -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    } 
    Write-Progress -activity "Start-sleep" -Status "Nastepne sprawdzenie polaczen za" -SecondsRemaining 0 -Completed
}

Function SendSlackMessage {
    param (
        [string] $message
    )

    $token = "slack-token"
    $send = (Send-SlackMessage -Token $token -Channel 'led_connections' -Text $message).ok
    ( -join ("Wiadomosc wyslana: ", $send))
}

# script
$serversArray = @()
foreach ($object in $servers) {
    $prop = [ordered]@{
        SN              = $object.name;   
        Localisation    = $object.placowka;
        IP              = $object.IP;
        LastCheckResult = "connected"
    }

    $hash = New-Object PSObject -property $prop
    $serversArray = [array]$serversArray + $hash
}

"`n"
do {
    # update
    $scriptMD5Check = (Get-FileHash -Path $myinvocation.mycommand.definition -Algorithm MD5).hash
    if ($scriptMD5.trim() -ne $scriptMD5Check.trim()) {
        "`n"
        Write-Host "Znaleziono nowy plik JSON, uruchamiam ponownie skrypt..." -BackgroundColor Black -ForegroundColor Blue
        $arguments = ( -join ("& ", $myinvocation.mycommand.definition))
        Start-Process powershell -ArgumentList $arguments
        Stop-process $PID
    }

    if (!(Test-Connection -ComputerName $serverSN -Count 3 -Quiet)) {
        #nie pinguje serwer
        Write-Host "VPN not connected!" -ForegroundColor Red
        Start-Sleep -Seconds 15

        #ponowne sprawdzenie polaczenia
        Write-Output "Re-checking VPN connection"

        if (!(Test-Connection -ComputerName $serverSN -Count 3 -Quiet)) {
            SendSlackMessage -message ( -join ("*Komputer, na ktorym jest uruchominy skrypt, nie ma polaczenia z VPN!*"))
        }
    }
    else {
        for ($i = 0; $i -le $qtyServers; $i++) {
            $sn = $serversArray[$i].sn
            $snIP = $serversArray[$i].ip
            $lok = $serversArray[$i].localisation

            $dateNow = get-date -DisplayHint date -Format MM/dd/yyyy
        
            if ($excludedList -notcontains $sn) {
                Write-Output ( -join ("Checking connection with: ", $sn, ", ", $lok)) 

                if (Test-Connection -ComputerName $snIP -Count 3 -Quiet) {
                    #maszyna pinguje
                    Write-Host ( -join ("Connected")) -ForegroundColor Green

                    if ($serversArray[$i].LastCheckResult -eq "not connected") {
                        SendSlackMessage -message ( -join ("*", $sn, "*, ", $lok, " - jest znowu polaczony"))
                    }
   
                    $serversArray[$i].LastCheckResult = "connected"
                }
                else {
                    #maszyna nie pinguje
                    Write-Host "Not connected" -ForegroundColor Red  
                    Start-Sleep -Seconds 15

                    #ponowne sprawdzenie polaczenia
                    Write-Output ( -join ("Re-checking connection with: ", $sn))
                    if (Test-Connection -ComputerName $snIP -Count 3 -Quiet) {
                        #maszyna pinguje
                        Write-Host ( -join ("Connected")) -ForegroundColor Green

                        if ($serversArray[$i].LastCheckResult -eq "not connected") {
                            SendSlackMessage -message ( -join ("*", $sn, "*, ", $lok, " - jest znowu polaczony"))
                        }

                        $serversArray[$i].LastCheckResult = "connected"
                    }
                    else {
                        #maszyna nie pinguje
                        Write-Host "Not connected" -ForegroundColor Red  
 
                        if ($serversArray[$i].LastCheckResult -eq "connected") {

                            $msg = ( -join ("*``", $sn, ", ", $lok, " - jest niepolaczony!``*"))

                            if((gc $csvPrem) -match $lok ) {
                                $headers = @((gc $csvPrem | select -First 1).tolower().replace(';', "_*").replace(" ", '_').Split('*') | select -Unique)  
                                $csv = import-csv $csvPrem -Header $headers -Delimiter ';'
                            }
                             
                            if((gc $csvSupe) -match $lok ) {
                                $headers = @((gc $csvSupe | select -First 1).tolower().replace(';', "_*").replace(" ", '_').Split('*') | select -Unique)
                                $csv = import-csv $csvSupe -Header $headers -Delimiter ';'  
                            }
                             
                            if((gc $csvCity) -match $lok ) {
                                $headers = @((gc $csvCity | select -First 1).tolower().replace(';', "_*").replace(" ", '_').Split('*') | select -Unique)  
                                $csv = import-csv $csvCity -Header $headers -Delimiter ';'
                            }

                            if((gc $csvPT) -match $lok ) {
                                $headers = @((gc $csvPT | select -First 1).tolower().replace(';', "_*").replace(" ", '_').Split('*') | select -Unique)  
                                $csv = import-csv $csvPT -Header $headers -Delimiter ';'
                            }

                            $simNumber = ($csv | where {$_.nazwa_.trim() -eq $lok.trim()}).restart_sms_

                            if(($null -eq $simNumber) -or ($simNumber -eq "")) {
                                $simNumber = "Brak numeru SIM w pliku CSV"
                            }

                            $msg = (-join($msg, "`n sim: ", $simNumber)) 

                            SendSlackMessage -message $msg
                        }

                        $serversArray[$i].LastCheckResult = "not connected"
                    }
                }

                "`n"
            }
        }
    }

    Start-SleepTimer 600
} until ($dateNow -gt $startDate)


$finalResult = @()
$serversArray | % { 
    if ($_.LastCheckResult -eq "not connected") {
        $finalResult += $_
    }
}

if ($finalResult.count -ne 0) {
    $msg = "*Niepolaczone ledy na koniec dnia - $($startDate)* ``````` - SN - LOKALIZACJA -`n**********************`n"

    foreach ($result in $finalResult) {
        $msg += ( -join ($result.sn, " - ", $result.Localisation, "`n"))
    }

    $msg += "``````` "
    SendSlackMessage -message $msg
}