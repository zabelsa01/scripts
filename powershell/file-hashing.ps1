# Define the log directory for the CSV file
$logdir = "C:\SplunkLogs"

# Define the timestamp that Splunk will read
$timestamp = (Get-Date -UFormat "%Y-%m-%d %H:%M:%S %Z00")

#Test and Make Splunk Log Directory
if((Test-Path -PathType Container $logdir) -eq 0) {
    mkdir $logdir
}

#Set the Date Format
$fileName_date = (Get-Date -UFormat %Y-%m-%d)

#Get a list of all EXE files
$files = @(ls c:\windows\system32 | where-object {$_.Name -like "*.exe"}) | select -expand FullName
$files += @(ls c:\windows\syswow64 | where-object {$_.Name -like "*.exe"}) | select -expand FullName
$files += @(ls c:\windows | where-object {$_.Name -like "*.exe"}) | select -expand FullName

#Hash all EXE files (POWERSHELL 2.0)
$hashlist+=foreach ($file in $files) {
    ls $file | select @{Name="Timestamp"; Expression = {$timestamp}}, @{Name="Report"; Expression = {get-date -f yyyy-MM-dd}}, CreationTime, LastWriteTime, FullName, @{Name="SHA256"; Expression = {get-filehash $file | select -expand Hash}}
    }
$hashlist | ConvertTo-Csv -NoTypeInformation | Select-Object -skip 1 | out-file -Append $logdir\hashes-$fileName_date.csv

#Hash all EXE files (POWERSHELL 4.0)
#foreach ($file in $files) {
#    ls $file | select @{Name="Timestamp"; Expression = {$timestamp}}, @{Name="Report"; Expression = {get-date -f yyyy-MM-dd}}, CreationTime, LastWriteTime, FullName, @{Name="SHA256"; Expression = {get-filehash $file | select -expand Hash}} | Export-Csv -NoTypeInformation -Append $logdir\hashes-$fileName_date.csv
#}