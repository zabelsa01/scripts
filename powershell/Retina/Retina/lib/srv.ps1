# $Data | where-object {$_.OS -like "*Windows Server*" -and $_.DNSName -notmatch '.*w+k+s.*'} | where-object {$_.DNSName -notmatch 'regex'}
$pmolist = @(gc 'E:\Retina Metrics\Scripts\lib\pmolist.txt') 
$Data | where-object {$pmolist -notcontains $_.IP} | where-object {$_.OS -like "*Windows Server*" -and $_.DNSName -notmatch '.*w+k+s.*' -and $_.NetBiosName -notmatch '.*w+k+s.*'}

