clear
$csvloc = ls "\\Path\1-Retina Data\Audit Lookup" | sort creationtime -descending | select -first 1 | select -expand FullName
$dat = get-date -uformat "%m%d%Y"

$ids = read-host "Enter the ID"
write-host 'Here are your results.'
import-csv $csvloc | where-object {$_.id -eq "$ids"}
write-host 'YOUR WELCOME!!!!'