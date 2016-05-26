$homedir = "E:\Retina Metrics"
cd $homedir
$scripts = "$homedir\scripts"
$z = ls "$homedir\MetricReports"
$oldICVA = Read-Host "Enter most recent past-due ICVA (in YYYY-A-#### format)"
if ($z.Length -ge 3) {mv .\MetricReports\*.* .\MetricReports\tmp}

# COMPLIE ALL CSVs
& "$scripts\CompileCSV.ps1"

. "$Scripts\lib\ImportCSV.ps1"

# RETINA REPORT GENERATION

& "$scripts\ICVAStatusAllIP.ps1"

& "$scripts\ICVAStatusBreakout.ps1"

& "$scripts\Export.ps1"

& "$scripts\RetinaMetricsHistorical5.ps1"

& "$scripts\Top10List5.ps1"

& "$scripts\PMO_Breakout_CSV.ps1"

& "$scripts\ICVA_Tracker.ps1"

& "$scripts\ICVA_Incident.ps1"

#Make Copies to the Collaborative Folder on the Share Drive
$dat = get-date -uformat "%m%d%Y"
mkdir "\\usafe\root\1 ACOS\Collaborative\SCXS\1-Retina Data\$dat"
mkdir "\\usafe\root\1 ACOS\Collaborative\SCXS\1-Retina Data\$dat\Breakout"
cp "$homedir\MetricReports\Breakout\*.*" "\\usafe\root\1 ACOS\Collaborative\SCXS\1-Retina Data\$dat\Breakout"
cp "$homedir\MetricReports\*.txt" "\\usafe\root\1 ACOS\Collaborative\SCXS\1-Retina Data\$dat\"
cp "$homedir\MetricReports\*.csv" "\\usafe\root\1 ACOS\Collaborative\SCXS\1-Retina Data\$dat\"



#Move all the previous results to an Archive Folder
if ((ls $homedir\MetricReports\).count -gt 1) {mkdir -f $homedir\MetricReports\Archived\$dat; mv $homedir\MetricReports\*.* $homedir\MetricReports\Archived\$dat; mv $homedir\MetricReports\Breakout $homedir\MetricReports\Archived\$dat} else {echo " "}
clear