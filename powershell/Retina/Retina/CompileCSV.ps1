$a = new-object -comobject wscript.shell
$b = $a.popup("IMPORTANT! If you are compiling multipe csv files, make sure they are all in a folder together before continuing. There should not be any other csv files in the folder except the ones used to complete the full class B scan. Have a great Air Force Day! ",0,"Informational Thingy",1)
if ($b -gt 1) {exit} else {echo "Well lets go..."}

$gdat = get-date -format ddMMMMyy
$dat = get-date -format MMM
$mdat = get-date -uformat "%m"

Function Select-FolderDialog
{
    param([string]$Description="Well...Browse to A Folder Already",[string]$RootFolder="Desktop")
    
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

$objForm = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm.Rootfolder = $RootFolder
    $objForm.Description = $Description
    $Show = $objForm.ShowDialog()
    If ($Show -eq "OK")
    {
        Return $objForm.SelectedPath
    }
    Else
    {
        Write-Error "Operation cancelled by user."; Exit
    }
}

Function GetHeaders
{
    $file = $list | select -first 1
    $headers = (gc $file | select -first 1) | foreach {$_ -replace '"',""}
    $remcomma = $headers[0..($headers.length - 2)]
    [string]$remcomma -replace " ","" >> $fileloc\temp.txt
}


$fileloc = Select-FolderDialog

$list = ls $fileloc/*.csv | where-object {$_.name -notlike "*Full*"} | select -expand fullname

GetHeaders 
foreach ($lists in $list) {gc $lists | select -skip 1 >> $fileloc\temp.txt}
import-csv $fileloc\temp.txt | export-csv $fileloc\$mdat-$dat-Full_Scan.csv -NoTypeInformation
cp $fileloc\$mdat-$dat-Full_Scan.csv "E:\Retina Metrics\RetinaRAWData"
del $fileloc\temp.txt
