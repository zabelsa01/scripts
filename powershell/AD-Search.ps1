<#
.NAME
	Falcon-Strike
	
.SYNOPSIS
	Executes Falcon Strike

.SYNTAX   
	Usage: powershell .\Falcon-Strike.ps1 [-GetList] [-Pickup.ps1]
		[-GetList]			- Recover output and cleanup remote host
		[-Pickup]				- Use WMI Process Call Create. Default=Schtasks
		
			
.DESCRIPTION 
		Stuff Stuff Stuff
		
.NOTES
	Name: 			Falcon-Strike.ps1	
	Author:  		WHCA
	Organization: 	United States Air Force
	Maintainer:  	Scott Zabel
	DateCreated: 	09 Sep 2014
	Version: 		1
	Updated: 		09 Sep 2014

.EXAMPLE

#>

[CmdletBinding()]
Param(	[Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$True)]
		[switch]$GetList,
		[switch]$Pickup
		)

function GetList {
$compname= read-host "Enter Computer Name"

write-host "Getting system list from Active Directory"
$wsfull = Get-ADComputer -Properties ipv4Address, OperatingSystem -LDAPfilter "(name=*$compname*)" -SearchBase "OU=Workstation Accounts,DC=WHCA,DC=mil" | where-object {$_.IPv4Address -ne $null }
$local = $wsfull | Where-Object {$_.IPv4Address -match "10.*"}
$local | Add-Member -force -type NoteProperty -name Targeted -value ([int]1)
$target = $local | select Name, IPv4Address, OperatingSystem, Targeted
$target | export-csv -NoTypeInformation D:\Tools\Stats\op-stats.csv
#$Executed = import-csv D:\Tools\Stats\op-stats.csv

write-host "Checking if system is reachable"
foreach ($i in $target.ipv4address) {
    $testcon = D:\Tools\Diagnostic\diagnostic.ps1 $i -ports 445
    if ($testcon.TCP445 -eq "Success") {echo $i >> D:\Tools\Helix_PSSurvey\targets.txt; D:\Tools\Helix_PSSurvey\Execute-RemoteTask.ps1 $i} else {echo $i >> D:\Tools\Helix_PSSurvey\failed.txt}
    }
} 
 
function Getem {
gc D:\Tools\Helix_PSSurvey\targets.txt | out-file D:\Tools\Helix_PSSurvey\Pickup.txt
foreach ($i in gc D:\Tools\Helix_PSSurvey\Pickup.txt) {
    $status = schtasks.exe /query /s $i /tn dcc_task
    if ($status | select-string -pattern "ready") {write-host "Picking up $i"; D:\Tools\Helix_PSSurvey\Execute-RemoteTask.ps1 $i -Pickup; (gc D:\Tools\Helix_PSSurvey\Pickup.txt) | where-object {$_ -notmatch "$i"} | set-content D:\Tools\Helix_PSSurvey\Pickup.txt} else {write-host "$i not ready"} 
    }
}



 
#$Executed = import-csv D:\Tools\Stats\op-stats.csv
#$Executed | Add-Member -force -type NoteProperty -name Targeted -value ([int]1+1)
#foreach ($i in $target) {$tmp=$executed | where-object {$_.ipv4address -eq "$i"} | select Targeted; $tmp | Add-Member -force -type NoteProperty -name Targeted -value} 

