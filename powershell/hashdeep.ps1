# Set some variables
$ts = (Get-Date -UFormat "%Y-%m-%d %H:%M:%S %Z00")
$logdir = "C:\Users\SAZabel\Desktop\Scripts\Scripts\testing\SplunkLogs"
$filename = (Get-Date -UFormat "%Y-%m-%d_%H-%M")
$OSinfo = gwmi win32_operatingsystem
$OSCaption = $OSinfo.Caption
$OSVersion = $OSinfo.Version
clv more_hashes
clv hash_ts
clv hashes

#Test and Make Splunk Log Directory
if((Test-Path -PathType Container $logdir) -eq 0) {
    mkdir $logdir
}

#Cleanup Directory
while ((ls C:\SplunkLogs).count -gt 30) {$cln = ls $logdir | sort creationtime -descending | select -last 1 | select -expand FullName; del $cln}

# Determine architecture and run appropriate executable
if ( $OSinfo.OSArchitecture -match "64-bit" ) {
    $hashes = & "C:\Program Files\SplunkUniversalForwarder\etc\apps\DS-all_departments-Input-windows_hashfiles\bin\hashdeep64.exe" -c 'md5,sha256' C:\Windows\*.exe C:\Windows\SysWOW64\*.exe C:\Windows\System32\*.exe
} else {
    $hashes = & "C:\Program Files\SplunkUniversalForwarder\etc\apps\DS-all_departments-Input-windows_hashfiles\bin\hashdeep.exe" -c 'md5,sha256' C:\Windows\*.exe C:\Windows\SysWOW64\*.exe C:\Windows\System32\*.exe
}

# Ditch the header lines
$more_hashes = $hashes | Select-Object -Skip 5

# Add the splunk-readable timestamp to each event
foreach ($i in $more_hashes) {
    [array]$hash_ts += "$ts," + "$i," + "$OSCaption," + "$OSVersion"
}

# Put this thing in a file.
$hash_ts | out-file $logdir\$filename-hashes.csv

