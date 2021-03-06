$homedir = "E:\Retina Metrics"
$scripts = "$homedir\scripts"
cd $homedir

#Import Retina CSV
. "$Scripts\lib\ImportCSV.ps1"

#Get Numbers
. "E:\Retina Metrics\Scripts\lib\pmobreakout.ps1"

#Count
$list = gc ./scripts/lib/pmobreakout.ps1 | foreach {$_.split()[0]} | sort
[array]$pmoname = @()
[array]$critlists = @()
[array]$highlists = @()
[array]$medlists = @()
$pmoname = $list -replace "\$", "" -replace "list", ""
foreach ($lists in $list) {
    #Count Critical
    $crit = (invoke-expression $lists | where-object {$_.Exploit -eq "Yes" -and $_.SevCode -eq "Category I"}).count
        if (!$crit) {$crit = 0}
        $critlists += $crit
    $high = (invoke-expression $lists | where-object {$_.Exploit -eq "Yes" -and $_.SevCode -ne "Category I"}).count
        if (!$high) {$high = 0}
        $highlists += $high
    $med = (invoke-expression $lists | where-object {$_.Exploit -ne "Yes" -and $_.SevCode -eq "Category I"}).count    
        if (!$med) {$med = 0}
        $medlists += $med
    write-host $lists "Total Critical:"$crit
    write-host $lists "Total High:"$high
    write-host $lists "Total Medium:"$med
           
}

#Create Object
$PMO = @()
$PMO = New-Object PSObject
$PMO | Add-Member NoteProperty PMO($pmoname)
$PMO | Add-Member NoteProperty Critical($critlists)
$PMO | Add-Member NoteProperty High($highlists)
$PMO | Add-Member NoteProperty Medium($medlists)


#Create Rows
[string]$row1 = "PMO, "; [string]$row1 += $PMO | select -expand PMO | foreach {[string]$_ + ","}
[string]$row2 = "Critical, "; [string]$row2 += $PMO | select -expand Critical | foreach {[string]$_ + ","}
[string]$row3 = "High, "; [string]$row3 += $PMO | select -expand High | foreach {[string]$_ + ","}
[string]$row4 = "Medium, "; [string]$row4 += $PMO | select -expand Medium | foreach {[string]$_ + ","}


#Excel Format
$file = "./tmp/temp.txt"
$row1 >> $file
$row2 >> $file
$row3 >> $file
$row4 >> $file
(gc $file | foreach {$_ -replace " ",""})| foreach {$_.trimend(",")} | set-content $file


# Export CSV
import-csv $file | export-csv ./MetricReports/PMO_TRACKER.csv -notype
rm $file

