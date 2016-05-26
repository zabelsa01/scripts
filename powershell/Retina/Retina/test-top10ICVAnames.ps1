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

#Top 10 Workstations 
function Top10WS
{
$CATI | where-object {$_.DNSName -match '[a-zA-Z]+[0][0-9].*'} | where-object {$_.DNSName -match '.*w+k+s.*'} | group dnsname | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 Servers 
function Top10SRV
{
$CATI | where-object {$_.DNSName -match '^[eE][uU].*[0][0-9].*' -or $_.DNSName -eq 'AF'} | where-object {$_.DNSName -match '[a-zA-Z]+[0][0-9].*' -or $_.DNSName -eq 'AF'} | where-object {$_.DNSName -notmatch '.*w+k+s.*'} | select dnsname | group dnsname | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 PMO
function Top10PMO
{
$CATI | where-object {$_.DNSName -match '[a-zA-Z]+[1-9][0-9].*|^[a-zA-Z]*$'} | where-object {$_.DNSName -ne '' -and $_.DNSName -ne 'Unknown' -and $_.DNSName -ne 'AF'} | select dnsname | group dnsname | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 NonWindows
function Top10NonWin
{
$CATI | where-object {$_.OS -notmatch '^Windows.*' -and $_.OS -notmatch '^Microsoft.*'} | select ip | group ip | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 ICVAs
function Top10ICVAs
{
$Data | Where-Object {$_.SevCode -eq "Category I"} |  where-object {$_.IAV -ne "N/A"} | 
group IAV | Sort-Object count -descending | select  count,name | 
select-object -first 10 #| ft -autosize
}

function Top10ICVANames
{
$Data | Where-Object {$_.SevCode -eq "Category I"} |  where-object {$_.IAV -ne "N/A"} | 
group IAV | Sort-Object count -descending | select  count,name | 
select-object -first 10
}

#Top 10 NonICVAs
function Top10NonICVAs
{
$Data | Where-Object {$_.SevCode -eq "Category I"} | where-object {$_.Name -notmatch "Zero-Day" -and $_.Name -notmatch "Vulnerabilit" -and $_.SevCode -eq "Category I" -and $_.FixInformation -notmatch "patch" -and $_.FixInformation -notmatch "version" -and ($_.OS -like "Window*" -or $_.OS -like "Microsoft*")} | group Name | sort-object count -descending | select count,name | select -first 10 | ft -autosize 
}

$homedir = "E:\Retina Metrics"
cd $homedir
if ((test-path variable:csv) -eq "true") {write-host "using" $csv} else {$csv = Get-Filename -initialDirectory "$homedir\RetinaRAWData"}
if ($Data.Length -gt 500) {write-host "Imported" $csv} else {$Data=import-csv "$csv"}
$CATI = $Data | Where-Object {$_.SevCode -eq "Category I"}

echo "Top 10 Workstations" >> ./MetricReports/Top10List.txt
Top10WS >> ./MetricReports/Top10List.txt
echo "Top 10 Servers" >> ./MetricReports/Top10List.txt
Top10SRV >> ./MetricReports/Top10List.txt
echo "Top 10 PMO Systems" >> ./MetricReports/Top10List.txt
Top10PMO >> ./MetricReports/Top10List.txt
echo "Top 10 Non Windows Systems" >> ./MetricReports/Top10List.txt
Top10NonWin >> ./MetricReports/Top10List.txt
echo "Top 10 ICVAs" >> ./MetricReports/Top10List.txt
Top10ICVAs >> ./MetricReports/Top10List.txt
echo "Top 10 Non ICVAs" >> ./MetricReports/Top10List.txt
Top10NonICVAs >> ./MetricReports/Top10List.txt
(gc ./MetricReports/Top10List.txt) | foreach {$_ -replace ".usafe.af.eucom.ic.gov", ""} | set-content ./MetricReports/Top10List.txt
(gc ./MetricReports/Top10List.txt) | where-object {$_ -match "[a-z]*"} | foreach {$_.ToUpper()} | set-content ./MetricReports/Top10List.txt
$ICVAnames = Top10ICVAnames | select -expand name
$names = foreach ($p in $ICVAnames) {$Data | where-object {$_.IAV -eq $p} | select -expand name -first 1 }
$a = foreach ($name in $names) {$name.split("(")[0] }
$ICVAtop10Count = Top10ICVAnames | select -expand count

