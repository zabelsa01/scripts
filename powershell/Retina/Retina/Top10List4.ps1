$homedir = "E:\Retina Metrics"
cd $homedir

#Import Retina CSV
. "$Scripts\lib\ImportCSV.ps1"

#Top 10 Workstations 
function Top10WS
{
$WSCATI | group dnsname | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 Servers 
function Top10SRV
{
$SRVCATI | select dnsname | group dnsname | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 PMO
function Top10PMO
{
$PMOCATI | select dnsname | group dnsname | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 NonWindows
function Top10NonWin
{
$CATI | where-object {$_.OS -notmatch '^Windows.*' -and $_.OS -notmatch '^Microsoft.*'} | select ip | group ip | Sort-Object count -descending | select -property count,name | select-object -first 10 | ft -autosize
}

#Top 10 ICVAs
function Top10ICVAs
{
$Data | where-object {$_.IAV -ne "N/A"} | group IAV | Sort-Object count -descending | select -property count,name | select-object -first 10 #| ft -autosize
}

#Top 10 NonICVAs
function Top10NonICVAs
{
$CATI | where-object {$_.Name -notmatch "Zero-Day" -and $_.FixInformation -notmatch "patch" -and $_.FixInformation -notmatch "version" -and ($_.OS -like "Window*" -or $_.OS -like "Microsoft*")} | group Name | sort-object count -descending | select count,name | select -first 10 | ft -autosize 
}

#Top 10 ICVA Table Creation
$tableName = "ICVATop10"

$ICVAtable = new-object system.data.datatable $tableName

$col1 = New-object system.data.datacolumn Count,([string])
$col2 = New-object system.data.datacolumn ICVA,([string])
$col3 = New-object system.data.datacolumn Name,([string])

$ICVAtable.columns.add($col1)
$ICVAtable.columns.add($col2)
$ICVAtable.columns.add($col3)

$CATI = $Data | Where-Object {$_.SevCode -eq "Category I"}

#Breakout Systems
$PMO = ./scripts/lib/pmo.ps1
$SRV = ./scripts/lib/srv.ps1
$WS = ./scripts/lib/ws.ps1

$PMOCATI = $PMO | Where-Object {$_.SevCode -eq "Category I"}
$SRVCATI = $SRV | Where-Object {$_.SevCode -eq "Category I"}
$WSCATI = $WS | Where-Object {$_.SevCode -eq "Category I"}

$ICVAnumber = Top10ICVAs | select -expand name
$fullnames = foreach ($p in $ICVAnumber) {$Data | where-object {$_.IAV -eq $p} | select -expand name -first 1 }
$names = foreach ($name in $fullnames) {$name.split("(")[0] }
$ICVAtop10Count = Top10ICVAs | select -expand count

#Add ICVA Top 10 Info to table
$counter = 0
foreach ($ICVA in $ICVAnumber){
    $row = $ICVAtable.newrow()
    $row.Count = $ICVAtop10Count[$counter]
    $row.ICVA = $ICVAnumber[$counter]
    $row.Name = $names[$counter]
    $ICVAtable.rows.add($row)
    $counter++
}

echo "Top 10 Workstations" >> ./MetricReports/Top10List.txt
Top10WS >> ./MetricReports/Top10List.txt
echo "Top 10 Servers" >> ./MetricReports/Top10List.txt
Top10SRV >> ./MetricReports/Top10List.txt
echo "Top 10 PMO Systems" >> ./MetricReports/Top10List.txt
Top10PMO >> ./MetricReports/Top10List.txt
echo "Top 10 Non Windows Systems" >> ./MetricReports/Top10List.txt
Top10NonWin >> ./MetricReports/Top10List.txt
echo "Top 10 ICVAs" >> ./MetricReports/Top10List.txt
$ICVATable | ft -auto >> ./MetricReports/Top10List.txt
echo "Top 10 Non ICVAs" >> ./MetricReports/Top10List.txt
Top10NonICVAs >> ./MetricReports/Top10List.txt
(gc ./MetricReports/Top10List.txt) | foreach {$_ -replace ".usafe.af.eucom.ic.gov", ""} | set-content ./MetricReports/Top10List.txt
(gc ./MetricReports/Top10List.txt) | where-object {$_ -match "[a-z]*"} | foreach {$_.ToUpper()} | set-content ./MetricReports/Top10List.txt
