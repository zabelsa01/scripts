$computer = read-host "Enter Computername"
write-host "ICVA RESULTS"
$icvaresults = $data | where-object {$_.dnsname -like "*$computer*"} | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"} | select IAV, Name, SevCode | sort IAV | fl
write-host $icvaresults
write-host "NON-ICVA RESULTS"
$nonicvaresults = $data | where-object {$_.dnsname -like "*$computer*"} | where-object {$_.IAV -eq "N/A"} | select Name, FixInformation, SevCode | fl
write-host $nonicvaresults
$icvaresults >> "E:\windows\temp\retina.txt"
$nonicvaresults >> "E:\windows\temp\retina.txt"
cmd /C notepad.exe "E:\windows\temp\retina.txt"
