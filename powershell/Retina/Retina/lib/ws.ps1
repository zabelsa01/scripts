# $Data | where-object {$_.OS -like "*XP*" -or $_.OS -like "*indows 7*"} | where-object {$_.DNSName -notmatch 'regex'}
$pmolist = @(gc 'E:\Retina Metrics\Scripts\lib\pmolist.txt')
$Data | where-object {$pmolist -notcontains $_.IP} | where-object {$_.OS -like "*XP*" -or $_.OS -like "*indows 7*"}
