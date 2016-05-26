# $Data | where-object {$_.DNSName -match '[a-zA-Z]+[1-9][0-9].*|^[a-zA-Z]*$'} | where-object {$_.DNSName -notmatch '.*[r][t][r][0-9].*' -and $_.DNSName -ne '' -and $_.DNSName -ne 'Unknown' -and $_.DNSName -ne 'AF'}
$pmolist = @(gc 'E:\Retina Metrics\Scripts\lib\pmolist.txt')
$Data | where-object {$pmolist -contains $_.IP} 