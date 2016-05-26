$homedir = "E:\Retina Metrics"
cd $homedir

function Scan {
    $arrImport = @(import-csv "$lists")
    $arrImport = $arrImport | where-object {($_.IAV -like "*-A-*") -or ($_.IAV -eq 'N/A' -and $_.Name -notmatch "Zero-Day" -and $_.FixInformation -notmatch "patch" -and $_.FixInformation -notmatch "version")}
    #Remove any Excluded or Waivered IAV
    $Exclude = @(gc "$homedir\Scripts\lib\IAVExclusions.txt"); $Exclude = foreach ($i in $Exclude) {$i.split(" ")[0]}
    $arrImport =  $arrImport | where-object {$Exclude -notcontains $_.IAV}

#Seperate Type of System
$PMOlist = @(gc 'E:\Retina Metrics\Scripts\lib\pmolist.txt')
$PMO = $arrImport | where-object {$pmolist -contains $_.IP}
$SRV = $arrImport | where-object {$pmolist -notcontains $_.IP} | where-object {$_.OS -like "*Windows Server*" -and $_.DNSName -notmatch '.*w+k+s.*' -and $_.NetBiosName -notmatch '.*w+k+s.*'}
$WS = $arrImport | where-object {$pmolist -notcontains $_.IP} | where-object {$_.OS -like "*XP*" -or $_.OS -like "*indows 7*"}
$NONWIN = $arrImport | where-object {$pmolist -notcontains $_.IP} | where-object {$_.OS -notmatch '^Windows.*' -and $_.OS -notmatch '^Microsoft.*'}


#Number of systems
    $WSnumber = $WS  | select DNSName -unique
    $SRVnumber = $SRV | select DNSName -unique
    $PMOnumber = $PMO | select DNSName -unique
    $NonWinnumber = $NONWIN | select ip -unique
    $auditunique = $arrImport | select AuditID -unique
    $auditnumber = $arrImport | select AuditID 

#Cat I Total
    $WSCATI = $WS | where-object {$_.SevCode -eq "Category I"} 
    $SRVCATI = $SRV | where-object {$_.SevCode -eq "Category I"} 
    $PMOCATI = $PMO | where-object {$_.SevCode -eq "Category I"}
    $NonWinCATI = $NONWIN | where-object {$_.SevCode -eq "Category I"}
    $AllCATI = $arrImport | where-object {$_.SevCode -eq "Category I"}
    
#Cat I High with Exploits
    $WSCATIHighExploit = $WSCATI | where-object {$_.Risk -eq "High"} | where-object {$_.Exploit -eq "Yes"} 
    $SRVCATIHighExploit = $SRVCATI | where-object {$_.Risk -eq "High"} | where-object {$_.Exploit -eq "Yes"} 
    $PMOCATIHighExploit = $PMOCATI | where-object {$_.Risk -eq "High"} | where-object {$_.Exploit -eq "Yes"}
    $NonWinCATIHighExploit = $NonWinCATI | where-object {$_.Risk -eq "High"} | where-object {$_.Exploit -eq "Yes"} 

#Cat I High
    $WSCATIHigh = $WSCATI | where-object {$_.Risk -eq "High"} 
    $SRVCATIHigh = $SRVCATI | where-object {$_.Risk -eq "High"}
    $PMOCATIHigh = $PMOCATI | where-object {$_.Risk -eq "High"}
    $NonWinCATIHigh = $NonWinCATI | where-object {$_.Risk -eq "High"} 

#Ratios
    $WSRatio = "{0:N2}" -f ($WSCATI.count / $WSnumber.count) 
    $SRVRatio = "{0:N2}" -f ($SRVCATI.count / $SRVnumber.count)
    $PMORatio = "{0:N2}" -f ($PMOCATI.count / $PMOnumber.count)
    $NonWinRatio = "{0:N2}" -f ($NonWinCATI.count / $NonWinnumber.count)
    
#IAV vs NA
    $NOIAV = $AllCATI | where-object {$_.IAV -eq 'N/A' -and $_.Name -notmatch "Zero-Day" -and $_.FixInformation -notmatch "patch" -and $_.FixInformation -notmatch "version"}
    $IAV = $arrImport | where-object {$_.IAV -match '.*[0-9].*'}
        
#GetFileDate
    #$filedate = ls $lists | select CreationTime | ft -hidetableheaders | out-string
    $filename = ls $lists | select Name | ft -hidetableheaders | out-string
    
#CSV Creation
    $b = $filename.trim() + "," + [string]$WSnumber.count + "," + [string]$SRVnumber.count + "," + [string]$PMOnumber.count + "," + [string]$NonWinnumber.count + "," + ([string]($WSnumber.count + $SRVnumber.count + $PMOnumber.count + $NonWinnumber.count)) + "," + [string]$WSCATIHighExploit.count + "," + [string]$SRVCATIHighExploit.count + "," + [string]$PMOCATIHighExploit.count + "," + [string]$NonWinCATIHighExploit.count + "," + [string]$WSCATIHigh.count + "," + [string]$SRVCATIHigh.count + "," + [string]$PMOCATIHigh.count + "," + [string]$NonWinCATIHigh.count + "," + [string]$WSCATI.count + "," + [string]$SRVCATI.count + "," + [string]$PMOCATI.count + "," + [string]$NonWinCATI.count + "," + [string]$WSRatio + "," + [string]$SRVRatio + "," + [string]$PMORatio + "," + [string]$NonWinRatio + "," + [string]$NOIAV.count + "," + [string]$IAV.count + "," + [string]$auditunique.count + "," + [string]$auditnumber.count   
    $b >> $csvfile
        
}

$csvfile = "./tmp/temp.txt"
$a = "Scan Date, Total WS, Total SRV, Total PMO, Total NonWin, Total Systems, WS CATI High Exploit, SRV CATI High Exploit, PMO CATI High Exploit, NonWin CATI High Exploit, WS CATI High, SRV CATI High, PMO CATI High, NonWin CATI High, WS CATI, SRV CATI, PMO CATI, NonWin CATI, WS Ratio, SRV Ratio, PMO Ratio, NonWin Ratio, NonIAVA, IAVA, Unique Audits, Total Audits"
$a > $csvfile
$list = ls ./RetinaRAWData/*.csv | sort creationtime -descending | select -first 3 | sort creationtime
foreach ($lists in $list) {Scan}
import-csv $csvfile | export-csv ./MetricReports/HistoricalRetinaStats.csv -NoTypeInformation
del $csvfile
