$homedir = "E:\Retina Metrics"
$scripts = "$homedir\scripts"
cd $homedir


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

#Get Numbers
. "E:\Retina Metrics\Scripts\lib\pmobreakout.ps1"

#HTML Code
$a = "<style>"
$a = $a + "BODY{background-color:white;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;background-color:lightblue}"
$a = $a + "TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black;background-color:white}"
$a = $a + "</style>"

#Count
$list = gc ./scripts/lib/pmobreakout.ps1 | foreach {$_.split()[0]} | sort
[string]$blah = ""
$table = @()
$i = 0
foreach ($lists in $list) {
    #Count Critical
    $pmoname = @()
    $critlists = @()
    $highlists = @()
    $medlists = @()
    $pmoname = $lists -replace "\$", "" -replace "list", ""
    $critlists = (invoke-expression $lists | where-object {$_.Exploit -eq "Yes" -and $_.SevCode -eq "Category I"}).count
    $highlists = (invoke-expression $lists | where-object {$_.Exploit -eq "No" -and $_.SevCode -eq "Category I"}).count
    $medlists = (invoke-expression $lists | where-object {$_.SevCode -eq "Category II"}).count     
    write-host $lists "Total Critical:"$critlists
    write-host $lists "Total High:"$highlists
    write-host $lists "Total Medium:"$medlists
    $table += New-Object PSObject
    $table[$i] | Add-Member NoteProperty PMO("$pmoname")
    $table[$i] | Add-Member NoteProperty Critical("$critlists")
    $table[$i] | Add-Member NoteProperty High("$highlists")
    $table[$i] | Add-Member NoteProperty Medium("$medlists")
    $blah += $table[$i] | convertto-html -fragment
    $i++
        
}

convertto-html -head $a -body "$blah" -Title "PMO VULNERABILITY STATUS" | out-file test.htm