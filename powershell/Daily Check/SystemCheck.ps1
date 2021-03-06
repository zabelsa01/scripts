#SETTING VARAIABLES
echo "ENTER YOUR ADMIN ACCOUNT"
echo "************************"
$cred = Get-Credential
$logPath = "\\path\dailycheck\scans"
$currDate = get-date -format MMMMdd
$SYMANTEC = "server1"
$LUMENSION  = "server2"
$INTRUST = "server3"
$RETINA1 = "server4"
$RETINA2 = "server5"
$RETINA3 = "server6"
$LC = "server7"
#$HBSS = "server8"
$arrSystems = @("$SYMANTEC", "$LUMENSION", "$INTRUST", "$RETINA1", "$RETINA2", "$RETINA3", "EURAMSAPP0030J")
$arrRetinas = @("$RETINA1", "$RETINA2", "$RETINA3")

#Ignoring SSL Errors
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

cls
#PING SYSTEMS FUNCTION
Function PingSys {
echo "                       CHECKING SERVER CONNECTIVITY"
echo "_______________________________________________________________________________"
foreach ($arrSystem in $arrSystems) {
    gwmi Win32_PingStatus -Filter "Address='$arrSystem'" 
    }
}

#CHECK SERVICES FUNCTION
Function ServiceCheck {
echo "                       CHECKING SERVICES ON ALL SERVERS"
echo "_______________________________________________________________________________"
echo ""
foreach ($arrSystem in $arrSystems) 
    {
    if ($arrSystem -eq "$SYMANTEC") 
        {
        echo $arrSystem
	echo "`n`n"
        gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "MSSQLSERVER"}  
        gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "SQLSERVERAGENT"} 
        gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "qserver"} 
        gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "IcePack"} 
        gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "ScanExplicit"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "semsrv"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "ccmexec"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "rpcss"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "lanmanserver"}
	echo "-----------------------------------------------" 
        }
    elseif ($arrSystem -eq "$LUMENSION")
        {
        echo $arrSystem
	echo "`n`n"
        gwmi win32_service -computername $LUMENSION -Credential $cred | where-object {$_.Name -eq "MSSQLSERVER"}  
        gwmi win32_service -computername $LUMENSION -Credential $cred | where-object {$_.Name -eq "SQLSERVERAGENT"} 
        gwmi win32_service -computername $LUMENSION -Credential $cred | where-object {$_.Name -eq "Symantec AntiVirus"} 
        gwmi win32_service -computername $LUMENSION -Credential $cred | where-object {$_.Name -eq "sxs"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "ccmexec"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "rpcss"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "lanmanserver"} 
        echo "-----------------------------------------------" 
        }
    elseif ($arrSystem -eq "$INTRUST")
        {
        echo $arrSystem
	echo "`n`n"
        gwmi win32_service -computername $INTRUST -Credential $cred | where-object {$_.Name -eq "MSSQLSERVER"}  
        gwmi win32_service -computername $INTRUST -Credential $cred | where-object {$_.Name -eq "SQLSERVERAGENT"} 
        gwmi win32_service -computername $INTRUST -Credential $cred | where-object {$_.Name -eq "Symantec AntiVirus"} 
        gwmi win32_service -computername $INTRUST -Credential $cred | where-object {$_.Name -eq "adcrpcs"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "ccmexec"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "rpcss"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "lanmanserver"} 
        echo "-----------------------------------------------" 
        }
    elseif ($arrSystem -eq "$RETINA1")
        {
        echo $arrSystem
	echo "`n`n"
        gwmi win32_service -computername $RETINA1 -Credential $cred | where-object {$_.Name -eq "MSSQLSERVER"}  
        gwmi win32_service -computername $RETINA1 -Credential $cred | where-object {$_.Name -eq "SQLSERVERAGENT"} 
        gwmi win32_service -computername $RETINA1 -Credential $cred | where-object {$_.Name -eq "Symantec AntiVirus"} 
        gwmi win32_service -computername $RETINA1 -Credential $cred | where-object {$_.Name -eq "RetinaEngine"} 
        gwmi win32_service -computername $RETINA1 -Credential $cred | where-object {$_.Name -eq "remcpsvc"} 
        gwmi win32_service -computername $RETINA1 -Credential $cred | where-object {$_.Name -eq "eEyeUpdateSchedulerSvc"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "ccmexec"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "rpcss"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "lanmanserver"} 
        echo "-----------------------------------------------" 
        }
    elseif ($arrSystem -eq "$RETINA3")
        {
        echo $arrSystem
	echo "`n`n"
        gwmi win32_service -computername $RETINA3 -Credential $cred | where-object {$_.Name -eq "MSSQLSERVER"}  
        gwmi win32_service -computername $RETINA3 -Credential $cred | where-object {$_.Name -eq "SQLSERVERAGENT"} 
        gwmi win32_service -computername $RETINA3 -Credential $cred | where-object {$_.Name -eq "Symantec AntiVirus"} 
        gwmi win32_service -computername $RETINA3 -Credential $cred | where-object {$_.Name -eq "RetinaEngine"} 
        gwmi win32_service -computername $RETINA3 -Credential $cred | where-object {$_.Name -eq "remcpsvc"} 
        gwmi win32_service -computername $RETINA3 -Credential $cred | where-object {$_.Name -eq "eEyeUpdateSchedulerSvc"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "ccmexec"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "rpcss"}
	gwmi win32_service -computername $SYMANTEC -Credential $cred | where-object {$_.Name -eq "lanmanserver"} 
        echo "-----------------------------------------------" 
        }                            
    }
}


#CHECK RETINA FUNCTION
Function Retina {
echo "                       CHECKING RETINA VERSION INFORMATION"
echo "_______________________________________________________________________________"
echo ""
echo "Current Retina Engine Version:"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
$web = New-Object Net.WebClient
$web.DownloadString("http://www.dia.ic.gov/admin/ds/iapc/retina.html") | out-file $logpath\tmp\temp.txt
$retinaupdate = gc $logpath\tmp\temp.txt | select-string -pattern "[1-9]\.[1-9][1-9]\.[1-9]" | select-object -last 1
$auditsearch = gc $logpath\tmp\temp.txt | select-string -pattern "audit_update" | select-object -first 1
$retinaversion = $retinaupdate | foreach {$_ -replace "<", "" -replace ">", "" -replace '\"', "" -replace ".*zip", "" -replace "/a", "" -replace "/li", "" -replace "--", ""}
$retinaversion = $retinaversion | foreach {$_ -replace "lia href=VAT/retina/","" -replace "-Release_Notes.txtRetina Engine 5.17.1 Release Notes",""} 
$retinaversion
echo ""
echo "Current Retina Audit Version:"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
$retinaaudit = $auditsearch | foreach {$_ -replace "<", "" -replace ">", "" -replace '\"', "" -replace ".*zip", "" -replace "/a", "" -replace "/td", ""}
$retinaaudit 
rm $logpath\tmp\temp.txt
echo ""
foreach ($arrRetina in $arrRetinas)
        {
	$HKLM = 2147483650
	$reg = gwmi -list -namespace root\default -computername $arrRetina  -Credential $cred | where-object {$_.name -eq "StdRegProv"}
	$keyvalue1 = $reg.GetStringValue($HKLM,"SOFTWARE\eeye\syncit\retina","LastUpdated") | select sValue
	$keyvalue2 = $reg.GetStringValue($HKLM,"SOFTWARE\eeye\syncit\retina","Version") | select sValue
	$keyvalue3 = $reg.GetStringValue($HKLM,"SOFTWARE\eeye\syncit\retina\Data\Audits","Version") | select sValue
	echo $arrRetina, $keyvalue1, $keyvalue2, $keyvalue3  | ft -autosize
        }
}


#CHECK INTRUST FUNCTION
Function Intrust {
echo "                       CHECKING INTRUST LOG COLLECTION:"
echo "_______________________________________________________________________________"
    get-eventlog -computername $INTRUST -log Intrust -newest 5000 | where-object {$_.Source -eq "InTrust Scheduled Tasks Manager"} | select -first 20 | select TimeGenerated, EntryType, Message | fl
	echo ""
}


#CHECK SYMANTEC FUNCTION
Function Symantec {
echo "                       CHECKING SYMANTEC DEFINITIONS"
echo "_______________________________________________________________________________"
echo ""
        $web2 = New-Object Net.WebClient
	$web2.DownloadString("http://www.dia.ic.gov/admin/ds/iapc/antivirus_updates.html") | out-file $logpath\tmp\temp2.txt
	$symantecsearch = gc "$logpath\tmp\temp2.txt" | select-string -pattern "[0-9]+.[a-zA-Z]+.[2][0-9]+" | select -last 1
	$symantecwebver = $symantecsearch | foreach {$_ -replace "<", "" -replace ">", "" -replace "td", "" -replace "/", "" -replace "tr", "" -replace " ", ""}
	$32bitver = gc "\\EURAMSAVS0005J\SymcData\sesmvirdef32\definfo.dat" | select-string "CurDefs"
	$64bitver = gc "\\EURAMSAVS0005J\SymcData\sesmvirdef64\definfo.dat" | select-string "CurDefs"
	echo "Current Symantec Virus Definition Date: $symantecwebver"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo ""
	echo "Symantec Virus Definition Date - 32bit"
	$32bitver
	echo ""
	echo "Symantec Virus Definition Date - 64bit"
	echo ""
	$64bitver
	rm $logpath\tmp\temp2.txt
}

#CHECK DRIVE SPACE FUNCTION
Function DriveCheck {
echo "                       CHECKING DRIVE SPACE"
echo "_______________________________________________________________________________"
echo ""
foreach ($arrSystem in $arrSystems) 
    {
        gwmi win32_logicaldisk -computer $arrSystem -Credential $cred | select @{Name="System"; Expression = {echo $arrSystem}}, DeviceID, VolumeName,@{Name="size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name="freespace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}}  | ft -autosize
	                         
    }
}


#CHECK UPTIME FUNCTION
Function Uptime {
echo "                       CHECKING SYSTEM UPTIME"
echo "_______________________________________________________________________________"
echo ""
foreach ($arrSystem in $arrSystems)
        {
	$Uptime = gwmi win32_operatingsystem -computer $arrSystem -Credential $cred
	$LastBootUpTime = $Uptime.ConvertToDateTime($Uptime.LastBootUpTime)
	$Time = (Get-Date) - $LastBootUpTime
	$Time | select @{Name="System"; Expression = {echo $arrSystem}}, Days, Hours, Minutes, Seconds | sort -property Days -Descending  | ft -autosize
        }
}

#CHECKING SYSTEM VULS FUNCTION
$filename = ls -Recurse "\\euramsrem0002j\e$\Retina Metrics\MetricReports\Archived\" -include SRV.csv | sort creationtime -descending | select -first 1 | select -expand FullName
$VulData = import-csv -path $filename | where-object {$_.IAV -like "*-A*"}
Function VulCheck {
echo "                       CHECKING SYSTEM VULNERABILITIES"
echo "_______________________________________________________________________________"
echo ""
foreach ($arrSystem in $arrSystems)
        {
        $VulData | where-object {$_.NetBIOSName -like "*$arrSystem*"} | select NetBIOSName, IAV, SevCode | sort IAV | ft -autosize
        }
}
        
#HEADER MESSAGE
Function Headmessage {
$name = whoami
$date = date
echo "Daily Check Completed By $name on $date"
echo "_______________________________________________________________________________"
echo ""
echo ""
}

#RUNNING FUNCTIONS
Headmessage 2>&1 | tee -variable message
PingSys 2>&1 | ft Address, StatusCode, Bytes, Time -auto | tee -variable pingresults 
ServiceCheck 2>&1 | ft Name, State, Status, StartMode -auto | tee -variable serviceresults
Retina 2>&1 | tee -variable retinaresults
$intrustresults = Intrust
$symantecresults = Symantec
DriveCheck 2>&1 | tee -variable driveresults
Uptime 2>&1 | tee -variable uptimeresults
VulCheck 2>&1 | tee -variable vulcheckresults


#EXPORTING RESULTS
$message >> "$logPath\$currDate.log"
$pingresults >> "$logPath\$currDate.log"
$serviceresults >> "$logPath\$currDate.log"
$retinaresults >> "$logPath\$currDate.log"
$intrustresults >> "$logPath\$currDate.log"
$symantecresults >> "$logPath\$currDate.log"
$driveresults >> "$logPath\$currDate.log"
$uptimeresults >> "$logPath\$currDate.log"
$vulcheckresults >> "$logPath\$currDate.log"
#$arrVirusDefs >> "$logPath\$currDate.log"


notepad.exe "$logPath\$currDate.log"
