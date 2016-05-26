$homedir = "E:\Retina Metrics"
cd $homedir

#powershell -sta
#File Selection Popup
Function Get-FileName($initialDirectory)
{
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
Out-Null

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.initialDirectory = $initialDirectory
$openFileDialog.filter = "All files (*.*)| *.*"
$OpenFileDialog.ShowDialog() | Out-Null
$OpenFileDialog.filename
} #end function get filename
echo 1

if ((test-path variable:csv) -eq "true") {write-host "using" $csv} else {$csv = Get-Filename -initialDirectory "$homedir\RetinaRAWData"}
if ($Data.Length -gt 500) {write-host "Imported" $csv} else {$Data=import-csv "$csv"}

echo 2
$Import = $Data | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}
echo 3
$counter = 1
#Builds hash table of total OS count
$OSname = $Import | select OS | group OS | select -expand name
$hash=@{}
foreach ($OSnames in $OSname) {
    clear
    write-host ("{0:N2}" -f (($counter/$OSname.count)*100))
    $arrResults = ($Import | where-object {$_.OS -eq $OSnames} | select -expand IP | sort-object -unique | measure-object).count
    $hash.add($OSnames,$arrResults)
    $counter++
    }

$counter = 1
#Returns Percent Complete
$IAV = $Import | select IAV | group IAV | select -expand name
echo "ICVA, Description, Category, Systems Applicable, Systems Vulnerable, Percent Complete" >> $homedir\tmp\IAVStat.txt
foreach ($IAVs in $IAV) {
    $OpenVul = ($Import | where-object {$_.IAV -eq "$IAVs"} | select -expand IP -unique | measure-object).count
    $value = 0
    $Import | where-object {$_.IAV -eq "$IAVs"} | select -expand OS -unique | foreach {$value+=$hash.get_item($_)}
    $Percent = "{0:N2}" -f ((($value - $OpenVul)/$value)*100)
    $Desc = $Import | where-object {$_.IAV -eq "$IAVs"} | select -first 1 -expand Name
    $Cat = $Import | where-object {$_.IAV -eq "$IAVs"} | select -expand SevCode -unique
    $IAVs = $IAVs -replace ","," "
    Write-host $IAVs
    Write-host $Desc
    Write-host $Cat
    Write-host "Total Vulnerable Systems:"$OpenVul
    Write-host "Total Systems Applicable:"$value
    Write-host "Percentage ICVA Complete:"$Percent "%"
    write-host ("Percentage script complete:" + "{0:N2}" -f (($counter/$IAV.count)*100))
    $csv2 = $IAVs+","+$Desc+","+$Cat+","+$value+","+$OpenVul+","+$Percent
    $csv2 >> $homedir\tmp\IAVStat.txt
    $counter++    
    }    
    
import-csv $homedir\tmp\IAVStat.txt | export-csv $homedir\MetricReports\IAVStat.csv -NoTypeInformation
del $homedir\tmp\IAVStat.txt 
