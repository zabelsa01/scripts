$homedir = "C:\nmap-5.21"
cd $homedir
$dat = get-date -uformat "%m%d%Y"
$firstsubnet=0
$lastsubnet=100
$ignoresubnet=252
$hostrange='1-254'
$portrange='0-65535'

do {
    if ($firstsubnet -eq $ignoresubnet) {
	$firstsubnet=$ignoresubnet+1
    }
    cmd /C nmap.exe -n -sS -T4 -p $portrange 192.168.$firstsubnet.$hostrange -oX ./logs/$firstsubnet.xml
    (gc ./logs/$firstsubnet.xml) | foreach-object {$_ -replace ".domain.com", ""} | set-content ./logs/$firstsubnet.xml 
    $firstsubnet++
}

while ($firstsubnet -le $lastsubnet)
