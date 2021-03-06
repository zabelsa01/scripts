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

$rtd = Get-Filename -initialDirectory "e:\eeye retina\scans"

$savefile = Read-host "Enter the name you would like to save the report as."

& "E:\eEye Retina\retina.exe" /rptvulncsv "E:\Retina Metrics\RetinaRAWData\$savefile.csv" $rtd

#rm "E:\Retina Metrics\RetinaRAWData\$savefile_JobMetrics.csv"