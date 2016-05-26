$homedir = "E:\Retina Metrics"
cd $homedir

#Import Retina CSV
. "$Scripts\lib\ImportCSV.ps1"

#Breakout Systems
$PMO = ./scripts/lib/pmo.ps1
$SRV = ./scripts/lib/srv.ps1
$WS = ./scripts/lib/ws.ps1

#Get unique dns names
$PMOunique = $PMO | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}| select DNSName -unique
$SRVunique = $SRV | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}| select DNSName -unique
$WSunique = $WS | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}| select DNSName -unique

#Get Total count of ICVAs for PMO, Servers, and WS
$PMOTotal = $PMO | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}
$SRVTotal = $SRV | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}
$WSTotal = $WS | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}

$PMOnumber = $PMOunique.count
$SRVnumber = $SRVunique.count
$WSnumber = $WSunique.count


#Returns Percent Complete
$counter = 1
$IAV = $Data | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"} | select IAV | group IAV | select -expand name
echo "ICVA, Description, Category, WS Total, SRV Total, PMO Total, WS Non-Compliant, SRV Non-Compliant, PMO Non-Compliant, WS Percent, SRV Percent, PMO Percent" >> $homedir\tmp\IAVBreakout.txt
foreach ($IAVs in $IAV) {
    $WSOpenVul = ($WSTotal | where-object {$_.IAV -eq "$IAVs"} | select -expand IP -unique | measure-object).count
    $SRVOpenVul = ($SRVTotal | where-object {$_.IAV -eq "$IAVs"} | select -expand IP -unique | measure-object).count
    $PMOOpenVul = ($PMOTotal | where-object {$_.IAV -eq "$IAVs"} | select -expand IP -unique | measure-object).count
    $value = 0
    $WSPercent = "{0:N2}" -f ((($WSnumber - $WSOpenVul)/$WSnumber)*100)
    $SRVPercent = "{0:N2}" -f ((($SRVnumber - $SRVOpenVul)/$SRVnumber)*100)
    $PMOPercent = "{0:N2}" -f ((($PMOnumber - $PMOOpenVul)/$PMOnumber)*100)
    $Desc = $Data | where-object {$_.IAV -eq "$IAVs"} | select -first 1 -expand Name
    $Cat = $Data | where-object {$_.IAV -eq "$IAVs"} | select -expand SevCode -unique
    $IAVs = $IAVs -replace ","," "
    Write-host $IAVs
    Write-host $Desc
    Write-host $Cat
    Write-host "Total Workstations:"$WSnumber
    Write-host "Total Servers:"$SRVnumber
    Write-host "Total PMO:"$PMOnumber
    Write-host "WS Non-Compliant:"$WSOpenVul
    Write-host "SRV Non-Compliant:"$SRVOpenVul
    Write-host "PMO Non-Compliant:"$PMOOpenVul
    Write-host "WS Percent:"$WSPercent "%"
    Write-host "SRV Percent:"$SRVPercent "%"
    Write-host "PMO Percent:"$PMOPercent "%"
    write-host ("Percentage script complete:" + "{0:N2}" -f (($counter/$IAV.count)*100))
    $csv2 = $IAVs+","+$Desc+","+$Cat+","+$WSnumber+","+$SRVnumber+","+$PMOnumber+","+$WSOpenVul+","+$SRVOpenVul+","+$PMOOpenVul+","+$WSPercent+","+$SRVPercent+","+$PMOPercent
    $csv2 >> $homedir\tmp\IAVBreakout.txt
    $counter++
    }    
    
import-csv $homedir\tmp\IAVBreakout.txt | export-csv $homedir\MetricReports\IAVBreakout.csv -NoTypeInformation
del $homedir\tmp\IAVBreakout.txt 
