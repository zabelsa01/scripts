$homedir = "E:\Retina Metrics"
cd $homedir

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

if ((test-path variable:csv) -eq "true") {write-host "using" $csv} else {$csv = Get-Filename -initialDirectory "$homedir\RetinaRAWData"}
if ($Data.Length -gt 500) {write-host "Imported" $csv} else {$Data=import-csv "$csv"}

$OSname = $Data | select OS | group OS | select -expand name
echo "OS,Count" >> $homedir\tmp\OSCount.txt
foreach ($OSnames in $OSname) {
    $Results = $Data | where-object {$_.OS -eq $OSnames} | select -expand IP | sort-object -unique | measure-object
    $OSnames = $OSnames -replace ",",""
    $csv2 = $OSnames+","+$Results.count
    $csv2 >> $homedir\tmp\OSCount.txt
    }
import-csv $homedir\tmp\OSCount.txt | export-csv $homedir\MetricReports\OSCount.csv -NoTypeInformation
del $homedir\tmp\OSCount.txt

   
