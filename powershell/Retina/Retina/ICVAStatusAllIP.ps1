$homedir = "E:\Retina Metrics"
cd $homedir

#Import Retina CSV
. "$Scripts\lib\ImportCSV.ps1"

$Import = $Data | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}

#Total IPs Scanned
$TotalIP = (import-csv "$csv" | select IP -unique | measure-object).count

#Returns Percent Complete
$counter = 1
$IAV = $Import | select IAV | group IAV | select -expand name
echo "ICVA, Description, Category, Systems Applicable, Systems Vulnerable, Percent Complete" >> $homedir\tmp\IAVStat_allIP.txt
foreach ($IAVs in $IAV) {
    $OpenVul = ($Import | where-object {$_.IAV -eq "$IAVs"} | select -expand IP -unique | measure-object).count
    $value = 0
    $Percent = "{0:N2}" -f ((($TotalIP - $OpenVul)/$TotalIP)*100)
    $Desc = $Import | where-object {$_.IAV -eq "$IAVs"} | select -first 1 -expand Name
    $Cat = $Import | where-object {$_.IAV -eq "$IAVs"} | select -expand SevCode -unique
    $IAVs = $IAVS.split(",") | select -first 1 
    Write-host $IAVs
    Write-host $Desc
    Write-host $Cat
    Write-host "Total Vulnerable Systems:"$OpenVul
    Write-host "Total Systems Applicable:"$TotalIP
    Write-host "Percentage ICVA Complete:"$Percent "%"
    write-host ("Percentage script complete:" + "{0:N2}" -f (($counter/$IAV.count)*100))
    $csv2 = $IAVs+","+$Desc+","+$Cat+","+$TotalIP+","+$OpenVul+","+$Percent
    $csv2 >> $homedir\tmp\IAVStat_allIP.txt
    $counter++
    }    
    
import-csv $homedir\tmp\IAVStat_allIP.txt | export-csv $homedir\MetricReports\IAVStat_allIP.csv -NoTypeInformation
del $homedir\tmp\IAVStat_allIP.txt 
