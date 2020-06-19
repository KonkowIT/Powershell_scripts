<#
 Marriott Corner
    sn2019 - Kamera
    sn2099 - PC
 Marriott I
    sn2033 - Kamera
    sn2040 - PC
 Pl. Unii
    sn2070 - Kamera
    sn2036 - PC
#>

# Youtube links
$linkPLU = "V5hYi70n51"
$linkM = "RwjhhEXQmy"
$linkMC = "L614CCwYuh"

# URL
$requestURL = 'http://api.db/request'
# Headers
$requestHeaders = @{'sntoken' = 'token'; 'Content-Type' = 'application/json' }

# Server SN
$serverSN = "1.1.1.1"

# Dont check this SN
$dontCheck = @(
    "sn1234", `
    "sn5678"
)

gc "C:\Metadane_do_skryptow\sn_disabled.txt" -ErrorAction SilentlyContinue | % { 
  if ($dontCheck -notcontains $_) {
      $dontCheck = [array]$dontCheck + $_
  }
}

# Metadata CSV
$csvPrem = "C:\Metadane_do_skryptow\meta_premium.csv"
$csvCity = "C:\Metadane_do_skryptow\meta_city.csv"
$csvSupe = "C:\Metadane_do_skryptow\meta_super.csv"

# HTML -File
$htmlSite = "C:\LedCameras\index.html"
$htmlSiteNew = "C:\LedCameras\LedCamerasNew.html"

# HTML - Page 
$begginning = @"
<!DOCTYPE html>
<html lang="pl-PL">

<head>
  <link rel="stylesheet" type="text/css" href="normalize.css" />
  <link rel="stylesheet" type="text/css" href="style.css" />
  <meta http-equiv="refresh" content="900">
  <meta charset="UTF-8">
  <link rel="icon" href="icon.png" />
  <title>
    SN Cameras LED
  </title>
</head>

<body>
  <div class="progress"></div>
  <center>
    <nav>
      <img style="height: auto; width:auto; box-shadow: none; margin: 0em 0em 0em 0em;"
        src="./sn_logo.png"
        alt="sn_logo">
    </nav>
    <p style="height: 1em;"></p>
  </center>
  <div class="grid-container">
    <div class="grid-container-cell">
      <iframe class="yt_link" src="https://www.youtube.com/embed/$($linkPLU)?autoplay=1&mute=1" frameborder="0" allow="autoplay;" allowfullscreen></iframe>
    </div>
    <div class="grid-container-cell">
      <iframe class="yt_link" src="https://www.youtube.com/embed/$($linkM)?autoplay=1&mute=1" frameborder="0" allow="autoplay;" allowfullscreen></iframe>
        <div class="btn-set" style="margin: 6% 0% 0% 0%;">
          <button class="button txt-ios btn-style"
            onclick="window.location.href = 'sms://012345678/&body=1234:off=0,1,2,3,4';">
            OFF
          </button>
          <button class="button txt-ios btn-style"
            onclick="window.location.href = 'sms://012345678/&body=1234:on=0,1,2,3,4';">
            ON
          </button>
          <button class="button txt-ios btn-style"
            onclick="window.location.href = 'sms://012345678/&body=1234:reboot=0,1,2,3,4';">
            Restart
          </button>
          <button class="button txt-android btn-style"
            onclick="window.location.href = 'sms:012345678?body=1234:off=0,1,2,3,4';">
            OFF
          </button>
          <button class="button txt-android btn-style"
            onclick="window.location.href = 'sms:012345678?body=1234:on=0,1,2,3,4';">
            ON
          </button>
          <button class="button txt-android btn-style"
            onclick="window.location.href = 'sms:012345678?body=1234:reboot=0,1,2,3,4';">
            Restart
          </button>
        </div>
    </div>
    <div class="grid-container-cell">
      <iframe class="yt_link" src="https://www.youtube.com/embed/$($linkMC)?autoplay=1&mute=1" frameborder="0" allow="autoplay;" allowfullscreen></iframe>
      <div class="btn-set" style="margin: 6% 0% 0% 0%;">
      <button class="button txt-ios btn-style"
        onclick="window.location.href = 'sms://012345678/&body=1234:off=0,1,2,3,4';">
        OFF
      </button>
      <button class="button txt-ios btn-style"
        onclick="window.location.href = 'sms://012345678/&body=1234:on=0,1,2,3,4';">
        ON
      </button>
      <button class="button txt-ios btn-style"
        onclick="window.location.href = 'sms://012345678/&body=1234:reboot=0,1,2,3,4';">
        Restart
      </button>
      <button class="button txt-android btn-style"
        onclick="window.location.href = 'sms:012345678?body=1234:off=0,1,2,3,4';">
        OFF
      </button>
      <button class="button txt-android btn-style"
        onclick="window.location.href = 'sms:012345678?body=1234:on=0,1,2,3,4';">
        ON
      </button>
      <button class="button txt-android btn-style"
        onclick="window.location.href = 'sms:012345678?body=1234:reboot=0,1,2,3,4';">
        Restart
      </button>
    </div>
    </div>
"@

$ending = @"
  </div>
  <center>
    <p>
      <img id="kk-logo"
        src="./konkowit_logo.png" 
        alt="konkowit_logo">
      <br>
      Made by KonkowIT &#169;
    </p>
  </center>
  <script>
    function getMobileOperatingSystem() {
      var userAgent = navigator.userAgent || navigator.vendor || window.opera;
      if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i) || userAgent.match(/iPod/i)) {
        document.getElementsByTagName('body')[0].className += ' ios';
        return 'iOS';
      }
      else if (userAgent.match(/Android/i)) {
        document.getElementsByTagName('body')[0].className += ' android';
        return 'Android';
      }
      else {
        document.getElementsByTagName('body')[0].className += ' unknown';
        return 'unknown';
      }
    }

    var deviceType = getMobileOperatingSystem();
    document.getElementById("device").innerHTML = deviceType;
  </script>
  <script>
    var h = document.documentElement,
      b = document.body,
      st = 'scrollTop',
      sh = 'scrollHeight',
      progress = document.querySelector('.progress'),
      scroll;

    document.addEventListener('scroll', function () {
      scroll = (h[st] || b[st]) / ((h[sh] || b[sh]) - h.clientHeight) * 100;
      progress.style.setProperty('--scroll', scroll + '%');
    });
  </script>
</body>

</html>
"@

$WindowsScriptShell = New-Object -ComObject wscript.shell

function GetComputers {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [ValidateNotNull()]
        [String]$networkName
    )
    
    # Body
    $requestBody = @"
{

"network": [$($networkName)]

}
"@

    # Request
    try {
        $request = Invoke-WebRequest -Uri $requestURL -Method POST -Body $requestBody -Headers $requestHeaders -ea Stop
    }
    catch [exception] {
        $Error[0]
        Exit 1
    }

    # Creating PS array of sn
    if ($request.StatusCode -eq 200) {
        $requestContent = $request.content | ConvertFrom-Json
    }
    else {
        Write-host ( -join ("Received bad StatusCode for request: ", $request.StatusCode, " - ", $request.StatusDescription)) -ForegroundColor Red
        Exit 1
    }

    $snList = @()
    $requestContent | % {
        if ((!($dontCheck -match $_.name)) -and ($_.lok -ne "LOK0014")) {
            $hash = [ordered]@{
                sn       = $_.name;
                ip       = $_.ip;
                lok_id   = $_.lok
                placowka = $_.lok_name.toString();
                sim      = "NULL";
            }

            $snList = [array]$snList + (New-Object psobject -Property $hash)
        }
    }

    return $snList
}

function Start-SleepTimer($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while ($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -activity "LED Cameras screenshots" -Status "Ponowne uruchomienie skryptu za" -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    } 
    Write-Progress -activity "LED Cameras screenshots" -Status "Ponowne uruchomienie skryptu za" -SecondsRemaining 0 -Completed
}

# Checking if Posh-SSH module is installed
if ($null -eq (Get-InstalledModule -name "Posh-SSH" -ErrorAction SilentlyContinue)) {
    "`n"
    Write-Host "Brak zainstalowanego modulu Posh-SSH koniecznego do korzystania ze skryptu" -ForegroundColor Red -BackgroundColor Black
    Start-sleep -s 1
    $arguments = "Write-host 'Instalacja modulu Posh-SSH';Install-PackageProvider nuget -force;install-module -name posh-ssh -force"
    Start-Process powershell -Verb runAs -ArgumentList $arguments -Wait
    "`n"
    
    if ($null -eq (Get-InstalledModule -name "Posh-SSH" -ErrorAction SilentlyContinue)) {
        Write-Host "Modul nie zostal poprawnie zainstalowany, sproboj zrobic to recznie" -ForegroundColor Red -BackgroundColor Black
        Break
    }
    else {
        Write-Host "Modul Posh-SSH zostal poprawnie zainstalowany" -ForegroundColor Green
    }
}

# Delete ss_temp directory if exists
if (test-path c:\LedCameras\ss_temp) {
    remove-item c:\LedCameras\ss_temp -Force -Recurse
}

$ledListV1 = GetComputers -networkName "`"LED City`", `"LED Premium`", `"Super Screen`""
sleep -s 5
$ledListV2 = GetComputers -networkName "`"LED City`", `"LED Premium`", `"Super Screen`""

$ledList = @()
for ($i = 0; $i -le (($ledListV1 | measure).count - 1); $i++) {

    # if empty string = "NULL"
    if (($ledListV1[$i].ip -eq "") -or ($ledListV1[$i].ip -eq $null)) {
        $ledListV1[$i].ip = "NULL"
    }

    if (($ledListV2[$i].ip -eq "") -or ($ledListV2[$i].ip -eq $null)) {
        $ledListV2[$i].ip = "NULL"
    }
    
    # both check not "NULL"
    if (($ledListV1[$i].ip -eq $ledListV2[$i].ip) -and ($ledListV1[$i].ip -ne "NULL") -and ($ledListV2[$i].ip -ne "NULL")) { 
        $ledList = [array]$ledList + $ledListV1[$i]
    }
    # first check "NULL" 
    elseif (($ledListV1[$i].ip -eq "NULL") -and ($ledListV2[$i].ip -ne "NULL")) { 
        $ledList = [array]$ledList + $ledListV2[$i]
    }
    # second check "NULL"
    elseif (($ledListV1[$i].ip -ne "NULL") -and ($ledListV2[$i].ip -eq "NULL")) {
        $ledList = [array]$ledList + $ledListV2[$i]
    }
    # both check "NULL"
    elseif (($ledListV1[$i].ip -eq "NULL") -and ($ledListV2[$i].ip -eq "NULL")) { 
        $ledList = [array]$ledList + $ledListV1[$i]
    }
    else {
        Write-Warning "Wartosc w polu `'IP`' tego LEDa jest nieprawidlowa!"
        $ledListV1[$i]
    }
}

for ($i = 0; $i -le (($ledList | measure).count - 1); $i++) {
    $lok = $ledList[$i].lok_id

    # Check in Led Premium
    if ((gc $csvPrem) -match $lok ) {
        $headers = @((gc $csvPrem | select -First 1).tolower().replace(';', "_*").replace(" ", '_').Split('*') | select -Unique)  
        $csv = import-csv $csvPrem -Header $headers -Delimiter ';'
    }
              
    # Check in Super Screen
    if ((gc $csvSupe) -match $lok ) {
        $headers = @((gc $csvSupe | select -First 1).tolower().replace(';', "_*").replace(" ", '_').Split('*') | select -Unique)
        $csv = import-csv $csvSupe -Header $headers -Delimiter ';'  
    }
                    
    # Check in Led City
    if ((gc $csvCity) -match $lok ) {
        $headers = @((gc $csvCity | select -First 1).tolower().replace(';', "_*").replace(" ", '_').Split('*') | select -Unique)  
        $csv = import-csv $csvCity -Header $headers -Delimiter ';'
    }

    # Check if not $null
    $simNumber = ($csv | where { $_.id_.trim() -eq $lok.trim() }).restart_sms_
    if(($simNumber -eq "") -or ($simNumber -eq $null) -or ($simNumber -eq "N/A")) {
        $simNumber = "NULL"
    }

    $ledList[$i].sim = $simNumber
}

# Check qty of LEDs
if (!(($ledListV1 | measure).count -eq ($ledList | measure).count)) {
    Write-Error "Ilosc LEDow nieprawidlowa"
    $arguments = ( -join ("& ", $myinvocation.mycommand.definition))
    Start-Process powershell -ArgumentList $arguments -WindowStyle Minimized
    Break
}

# ss_temp 
$filePath = "C:\LedCameras\ss_temp" 
if (!(Test-Path -path $filePath)) {
    $filePath = New-Item -ItemType Directory -Path $filePath -Force
}

# VPN not connected
if (!(Test-Connection -ComputerName $serverSN -Count 3 -Quiet)) {
    do {
        Write-Host "VPN not connected" -ForegroundColor Red
        $arg = "& `'c:\screennetwork\admin\check-vpn.bat`'" 
        Start-Process powershell.exe -ArgumentList $arg -Wait verb RunAs
    }
    until(Test-Connection -ComputerName $serverSN -Count 3 -Quiet)
}
# VPN connected
else {
    foreach ($led in $ledList) {
        $snIP = $led.ip
        $sn = $led.sn
        $snLoc = $led.placowka.toString()
        $filePathDownloaded = New-Item -ItemType Directory -Path ( -join ($filePath, "`\", $sn)) -Force

        $scriptBlock = {
            $sn = $args[0]
            $snIP = $args[1]
            $snLoc = $args[2]
            $filePathDownloaded = $args[3]

            # SSH
            $username = "sn"
            $secpasswd = ConvertTo-SecureString "sn_sshpass" -AsPlainText -Force
            $credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secpasswd
            $authenticationKey = ( -join ($($env:USERPROFILE), "\.ssh\ssh-key"))

            # Screenshot remote path
            $ssPath = "/c:/screennetwork/player/screenshot_lan_camera.jpg"
            
            if ($snIP -eq "NULL") {
                Write-host "`nBrak polaczenia z komputerem: "$sn" - "$snLoc  -ForegroundColor Red
                copy-item "C:\LedCameras\errorConnection.jpg" -Destination $filePathDownloaded -Force
                gci $filePathDownloaded -Recurse -Include "*.jpg" | % { rename-item $_ -NewName "screenshot_lan_camera.jpg" -Force }
            }
            else {
                try {
                    New-SFTPSession -ComputerName $snIP -Credential $credential -KeyFile $authenticationKey -ConnectionTimeout 300 -force -ErrorAction Stop -WarningAction silentlyContinue | out-null
                    $getSFTPSessionId = (Get-SFTPSession | Where-Object { $_.Host -eq $snIP }).SessionId
                }
                catch {
                    Write-host "`nBrak polaczenia z komputerem: "$sn" - "$snLoc  -ForegroundColor Red
                    copy-item "C:\LedCameras\errorConnection.jpg" -Destination $filePathDownloaded -Force
                    gci $filePathDownloaded -Recurse -Include "*.jpg" | % { rename-item $_ -NewName "screenshot_lan_camera.jpg" -Force }
                }

                if($getSFTPSessionId -ne $null) {
                    if ((Test-SFTPPath -SessionId $getSFTPSessionId $ssPath) -and (((Get-SFTPPathAttribute -SessionId $getSFTPSessionId $ssPath).LastwriteTime) -gt ((get-date).AddMinutes(-10)))) {
                        Write-host "`nDownloading screenshot from:"$sn" - "$snLoc
                        try {
                            Get-SFTPFile -SessionId $getSFTPSessionId -LocalPath $filePathDownloaded -RemoteFile $ssPath -Overwrite -verbose 
                        }
                        catch {
                            Write-host "`nProblem z pobieraniem zrzutu: "$sn" - "$snLoc -ForegroundColor Red
                            copy-item "C:\LedCameras\errorSS.jpg" -Destination $filePathDownloaded -Force 
                            gci $filePathDownloaded -Recurse -Include "*.jpg" | % { rename-item $_ -NewName "screenshot_lan_camera.jpg" -Force }
                        }
                    }
                    else {
                        Write-host "`nBrak nowego zrzutu ekranu: "$sn" - "$snLoc -ForegroundColor Red
                        copy-item "C:\LedCameras\errorSS.jpg" -Destination $filePathDownloaded -Force 
                        gci $filePathDownloaded -Recurse -Include "*.jpg" | % { rename-item $_ -NewName "screenshot_lan_camera.jpg" -Force }
                    }

                    Write-Host ( -join ("Closing SFTP connection: ", (Remove-SFTPSession -SessionId $getSFTPSessionId)))
                }
            }
        }

        Start-Job -ScriptBlock $scriptBlock -Name $sn -ArgumentList $sn, $snIP, $snLoc, $filePathDownloaded
    }

    # Wait all jobs
    Get-Job | Wait-Job

    # Receive all jobs
    Get-Job | Receive-Job

    # Remove all jobs
    Get-Job | Remove-Job
}

# Delete previous html
Remove-Item $htmlSite -force -ea SilentlyContinue

# Delete previous ss
Remove-Item "C:\LedCameras\ss" -force -Recurse -ea SilentlyContinue

# Rename ss_temp to ss
Rename-Item $filePath -NewName "ss"

# HTML
# Create
New-item -Path "C:\LedCameras\" -Name "LedCamerasNew.html" -ItemType file -force | out-null 
# Add begginning
ac $htmlSiteNew -Value $begginning
# Add ss
gci "C:\LedCameras\ss\" -Recurse -Include "*.jpg" | % { 
    # Add ss - img and text
    $imgSN = $_.Directory.name
    $imgLokalizacja = ($ledList | where { $_.sn -match $imgSN }).placowka.toString()
    $contentSN= @"
        <a href="#$($imgSN)">
          <img src="./ss/$($imgSN)/screenshot_lan_camera.jpg"
              alt="$($imgSN)">
        </a>
        <a href="#_" class="lightbox" id="$($imgSN)">
          <img src="./ss/$($imgSN)/screenshot_lan_camera.jpg"
              alt="$($imgSN)">
        </a>
        <div class="grid-item-text">
          $($imgSN) - $($imgLokalizacja)
        </div>
"@
    # Add ss - sim
    $simNumber = ($ledList | where {$_.sn -eq $imgSN}).sim

    if($simNumber -ne "NULL"){
        $contentSMS= @"
        <div class="btn-set">
          <button class="button txt-ios btn-style"
            onclick="window.location.href = 'sms://$($simNumber)/&body=1234:off=0,1,2,3,4';">
            OFF
          </button>
          <button class="button txt-ios btn-style"
            onclick="window.location.href = 'sms://$($simNumber)/&body=1234:on=0,1,2,3,4';">
            ON
          </button>
          <button class="button txt-ios btn-style"
            onclick="window.location.href = 'sms://$($simNumber)/&body=1234:reboot=0,1,2,3,4';">
            Restart
          </button>
          <button class="button txt-android btn-style"
            onclick="window.location.href = 'sms:$($simNumber)?body=1234:off=0,1,2,3,4';">
            OFF
          </button>
          <button class="button txt-android btn-style"
            onclick="window.location.href = 'sms:$($simNumber)?body=1234:on=0,1,2,3,4';">
            ON
          </button>
          <button class="button txt-android btn-style"
            onclick="window.location.href = 'sms:$($simNumber)?body=1234:reboot=0,1,2,3,4';">
            Restart
          </button>
        </div>
"@
    }

    # Adding
    ac $htmlSiteNew -Value '      <div class="grid-container-cell">'
    ac $htmlSiteNew -Value $contentSN -Encoding UTF8
    if ($contentSMS -ne $null) { ac $htmlSiteNew -Value $contentSMS }
    ac $htmlSiteNew -Value '      </div>'

    # Clean variables
    $contentSN = $null
    $contentSMS = $null
    $imgLokalizacja = $null
    $imgSN = $null
}
# Add ending
ac $htmlSiteNew -Value $ending

# Rename
Rename-item $htmlSiteNew -NewName "index.html" -Force

# Upload
"`n"
cd "C:\LedCameras"
docker login gitlab.test:1234 --username "test.test@test.pl" --password "test"
docker build -t gitlab.test:1234/led-streams .
docker push gitlab.test:1234/led-streams
docker logout
"`n"
sleep -s 10

# Refresh html
if ($WindowsScriptShell.AppActivate('Chrome')) {
  Write-Output "`nRefreshing page"
  $WindowsScriptShell.SendKeys('{F5}')
  sleep -s 5
  $WindowsScriptShell.SendKeys('{ENTER}')
}
Else {
  Write-Output "`nChrome is not started!`n Launching..."
  #Start-Process "chrome.exe" "http://test.test.pl/"
  Start-Process "chrome.exe" $htmlSite
  sleep -s 5
  $WindowsScriptShell.SendKeys('{ENTER}')
}

# Restart script
Start-SleepTimer 180
$arguments = "& 'C:\LedCameras\LEDCameras_API.ps1'"
Start-Process powershell -ArgumentList $arguments -WindowStyle Minimized
Break