<#
.NAME
	Falcon-Strike
	
.SYNOPSIS
	Executes Falcon Strike

.SYNTAX   
	Usage: powershell .\Falcon-Strike.ps1 [-Help] [-GetList] [-Deploy] [-DeployAuto] [-Pickup] [Analyze]
		[-Help]				- View usage examples	
        [-GetList]			- Get an AD list of system
        [-Deploy]			- Verify connectivity and deploy tasks to online systems
		[-DeployAuto]		- Automatic Deployment and Pickup
        [-Pickup]			- Pickup em up
        [-PickupAuto]       - Automatick Pickup
        [-Analyze]			- Analyze the current day's surveys
        [-VTSearch]         - Searches unknown hashes agains Virus Total
        [-Stats]            - Provides Falcon Strike Statistics
		
			
.DESCRIPTION 
		Stuff Stuff Stuff
		
.NOTES
	Name: 			Falcon-Strike.ps1	
	Author:  		WHCA
	Organization: 	WHCA
	Maintainer:  	Scott Zabel
	DateCreated: 	09 Sep 2014
	Version: 		1
	Updated: 		11 Sep 2014

.EXAMPLE

#>

[CmdletBinding()]
Param(	[Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$True)]
		[switch]$GetList,
        [switch]$Deploy,
		[switch]$DeployAuto,
        [switch]$Pickup,
        [switch]$PickupAuto,
        [switch]$Analyze,
        [switch]$VTSearch,
        [switch]$Stats,
        [switch]$Help
		)

$date = get-date -uformat "%Y%m%d"
$homedir = "D:\Tools\Falcon-Strike"

function Get-List {
    clear
    $date = get-date -uformat "%Y%m%d"
    $compname= read-host "Enter Computer Name"
    if (!(test-path $homedir\OPDATA\$date)) {
        mkdir $homedir\OPDATA\$date
    }

    write-host "Getting system list from Active Directory"
    $wsfull = Get-ADComputer -Properties ipv4Address, OperatingSystem -LDAPfilter "(name=*$compname*)" -SearchBase "OU=Workstation Accounts,DC=WHCA,DC=mil" | where-object {$_.IPv4Address -ne $null }
    $local = $wsfull | Where-Object {$_.IPv4Address -match "10.*"}
    $local | Add-Member -force -type NoteProperty -name Targeted -value ([int]1)
    $target = $local | select Name, IPv4Address, OperatingSystem, Targeted
    $target | select -expand Name | out-file $homedir\OPDATA\$date\ADlist.txt
    $a = (gc $homedir\OPDATA\$date\ADlist.txt).count
    #clear
    Write "There are $a systems targeted"
} 
 
function Deploy {
    clear
    $date = get-date -uformat "%Y%m%d"
    $target = gc $homedir\OPDATA\$date\ADlist.txt
    del -erroraction SilentlyContinue $homedir\OPDATA\$date\Targets.txt
    write-host "Checking if system is reachable"
    
    foreach ($i in $target) {
        $testcon = D:\Tools\Diagnostic\diagnostic.ps1 $i -ports 445
        if ($testcon.TCP445 -eq "Success") {
            echo $i | out-file -Append $homedir\OPDATA\$date\targets.txt; powershell.exe $homedir\Execute-RemoteTask.ps1 $i
        } else {
            write-host "(X): $i is Offline"; write-output -encoding ASCII "$i is Offline" | out-file -encoding ASCII -Append $homedir\OPDATA\$date\Failed.txt; (gc $homedir\OPDATA\$date\Failed.txt) | sort -Unique | Set-Content $homedir\OPDATA\$date\Failed.txt
        }
    }
    
    $a = (gc $homedir\OPDATA\$date\targets.txt).count
    if($a -eq 1) {
        Write-Host ""
        Write-Host "----------------------------"
        Write-Host "There is $a system1 deployed"
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "-----------------------------"
        Write-Host "There are $a systems deployed"
        Write-Host ""
    }
}

function DeployAuto {
    clear
    powershell.exe $homedir\Falcon-Strike.ps1 -Deploy
    $count=0
    $count2=144
    while ($count -lt $count2) {
        powershell.exe $homedir\Falcon-Strike.ps1 -Pickup
        start-sleep -Seconds 300
        $count=$count+1
        if ((gc $homedir\OPDATA\$date\Pickup.txt).count -le 0) {
            $count=$count2
        }
    }
}


function Pickup {
    clear
    $date = get-date -uformat "%Y%m%d"
    if ($resultsdir -ne $null) {$date = $resultsdir; $date = $date.Split("\")[4]} 
    if (!(Test-Path $homedir\OPDATA\$date\Pickup.txt)) {
        gc $homedir\OPDATA\$date\targets.txt | out-file $homedir\OPDATA\$date\Pickup.txt
    }
    
    function check {
        foreach ($i in (gc $homedir\OPDATA\$date\Targets.txt)) {
            if (ls -erroraction SilentlyContinue $homedir\OPDATA\$date\$i\HostSurvey.xml) {
                (gc $homedir\OPDATA\$date\Pickup.txt) | where-object {$_ -notmatch "$i"} | out-file $homedir\OPDATA\$date\Pickup.txt; write-output $i | out-file -encoding ASCII -Append $homedir\OPDATA\$date\Success.txt; (gc $homedir\OPDATA\$date\Success.txt) | sort -Unique | Set-Content $homedir\OPDATA\$date\Success.txt
            }
        }
    }
    
    check
    foreach ($b in (gc $homedir\OPDATA\$date\Pickup.txt)) {
        if (Test-Connection -ErrorAction SilentlyContinue -count 1 $b) {
            $status = schtasks.exe /query /s $b /tn dcc_task
            if ($status | select-string -pattern "ready") {
                powershell.exe $homedir\Execute-RemoteTask.ps1 $b -Pickup
            } elseif (($status | select-string -pattern "queued") -or ($status | select-string -pattern "running")) {
                write-host "$b not ready"
            } elseif ($status -eq $null) {
                write-host "$b timed out"
                (gc $homedir\OPDATA\$date\Pickup.txt) | where-object {$_ -notmatch "$b"} | out-file $homedir\OPDATA\$date\Pickup.txt; write-output $b | out-file -encoding ASCII -Append $homedir\OPDATA\$date\Failed.txt; (gc $homedir\OPDATA\$date\Failed.txt) | sort -Unique | Set-Content $homedir\OPDATA\$date\Failed.txt
            } else {
                #write-host "(X): $b failed pickup - offline"; write-output "$b failed pickup - offline" | Out-File -encoding ASCII -Append Join-Path $homedir\OPDATA\$date\Failed.txt; (gc Join-Path $homedir\OPDATA\$date\Failed.txt) | sort -Unique | Set-Content Join-Path $homedir\OPDATA\$date\Failed.txt
                (gc $homedir\OPDATA\$date\Pickup.txt) | where-object {$_ -notmatch "$b"} | out-file $homedir\OPDATA\$date\Pickup.txt; write-output $b | out-file -encoding ASCII -Append $homedir\OPDATA\$date\Failed.txt; (gc $homedir\OPDATA\$date\Failed.txt) | sort -Unique | Set-Content $homedir\OPDATA\$date\Failed.txt
            }
        }
    }

    check
    $leftover = (gc -erroraction SilentlyContinue $homedir\OPDATA\$date\Pickup.txt).count
    if($leftover -eq 1) {
        Write-Host ""
        Write-Host "-----------------------------------------"
        Write-Host "There is $leftover system to be picked up"
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "-------------------------------------------"
        Write-Host "There are $leftover systems to be picked up"
        Write-Host ""
    }
    if ((gc -erroraction SilentlyContinue $homedir\OPDATA\$date\Pickup.txt).count -lt "1") {
        del $homedir\OPDATA\$date\Pickup.txt
    }
}

function PickupAuto {
    clear
    #Select Directory
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [System.Windows.Forms.MessageBox]::Show("Select the OPDATA you are working with.") 
    function Select-Folder($message='Select a folder', $path = 0) { 
        $object = New-Object -comObject Shell.Application   
        $folder = $object.BrowseForFolder(0, $message, 0, $path) 
        if ($folder -ne $null) { 
            $folder.self.Path 
        } 
    }
    $resultsdir = Select-Folder 'Select the OPDATA you are working with.' 
    $count=0
    $count2=144
    while ($count -lt $count2) {
        Pickup
        start-sleep -Seconds 300
        $count=$count+1
        if ((gc $homedir\OPDATA\$resultsdir\Pickup.txt).count -le 0) {
            $count=$count2
        }
    }
    Remove-Variable -ErrorAction SilentlyContinue resultsdir
}

function Analyze {
    clear
    powershell.exe $homedir\Analyze-HelixSurvey.ps1 -StartOp $homedir\OPDATA\$date -Reprocess
}

function Help {
        clear
        write-host "Usage: powershell .\Falcon-Strike.ps1 [-Help] [-GetList] [-Deploy] [-DeployAuto] [-Pickup] [Analyze]"
		write-host "[-Help]				- View usage examples"	
        write-host "[-GetList]			- Get an AD list of system"
        write-host "[-DeployAuto]		- Automatic Deployment and Pickup"
        write-host "[-Pickup]			- Pickup em up"
        write-host "[-PickupAuto]       - Automatick Pickup"
        write-host "[-VTSearch]         - Searches unknown hashes agains Virus Total"
        write-host "[-Stats]            - Provides Falcon Strike Statistics"
        write-host "[-Analyze]			- Analyze the current day's surveys"
}


if ($GetList) {Get-List}
if ($Deploy) {Deploy}
if ($DeployAuto) {DeployAuto}
if ($Pickup) {Pickup}
if ($PickupAuto) {PickupAuto}
if ($Analyze) {Analyze}
if ($VTSearch) {Powershell.exe $homedir\VirusTotal.ps1}
if ($Stats) {Powershell.exe $homedir\stats.ps1}
if ($Help) {Help}

#Schedule Tasks to Pickup
#schtasks.exe /create /TN "Falcon-Strike" /RL Highest /TR "Powershell.exe -noexit & powershell.exe $homedir\Falcon-Strike.ps1 -DeployAuto" /SC ONCE /ST 18:00
#& schtasks.exe /run /u whca.mil\sazabeladm /TN "Falcon-Strike"
#schtasks.exe /query /TN "Falcon-Strike"
#schtasks.exe /end /TN "Falcon-Strike"
#schtasks.exe /delete /F /TN "Falcon-Strike"

<#
NOTES (things left to do):

- Output the 'failed.txt' file as a CSV vs. a plain text file
- Decide on upper or lower case file names.
- Fix wlupdate

#>