#$homedir = "E:\Retina Metrics"
#$scripts = "$homedir\scripts"
#cd $homedir


#File Selection Popup
#powershell -sta
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

#create excel doc
$xl=new-object -comobject "excel.application"
$wb=$xl.workbooks.add()
$ws=$wb.activesheet

$cells=$ws.cells

$cells.item(1,1)="PMO Breakout"
$cells.item(1,1).font.bold=$true
$cells.item(1,1).font.size=18

#define row/column start
$row=3
$col=1

#insert column headings
"PMO","Critical","high","medium" | foreach {
    $cells.item($row,$col)=$_
    $cells.item($row,$col).font.bold=$true
    $col++
    }

#Get Numbers
. "C:\Test\powershell\pmobreakout.ps1"


#Count
$list = gc "C:\Test\powershell\pmobreakout.ps1" | foreach {$_.split()[0]}
foreach ($lists in $list) {
    $row++
    $col=1
    $cells.item($row,$col)=$lists
    $col++
    #Count Critical
    $critlists = (invoke-expression $lists | where-object {$_.Exploit -eq "Yes" -and $_.SevCode -eq "Category I"}).count
    if (!$critlists) {$critlists = 0}
    $cells.item($row,$col)=$critlists
    $col++
    #Count High
    $highlists = (invoke-expression $lists | where-object {$_.Exploit -eq "No" -and $_.SevCode -eq "Category I"}).count
    if (!$highlists) {$highlists = 0}
    $cells.item($row,$col)=$highlists
    $col++
    #Count Medium
    $medlists = (invoke-expression $lists | where-object {$_.SevCode -eq "Category II"}).count
    if (!$medlists) {$medlists = 0}
    $cells.item($row,$col)=$medlists
    $col++
    
write-host $lists "Total Critical:"$critlists
write-host $lists "Total High:"$highlists
write-host $lists "Total Critical:"$medlists

}

$xl.visible=$true