$homedir = "E:\Retina Metrics"
cd $homedir

$dat = get-date -uformat "%m%d%Y"
mkdir -f $homedir\MetricReports\Breakout
#if ((ls $homedir\MetricReports\Breakout\*.csv).count -gt 1) {mkdir -f $homedir\MetricReports\Breakout\$dat; mv $homedir\MetricReports\Breakout\*.csv $homedir\MetricReports\Breakout\$dat} else {echo " "}
#clear

#Import Retina CSV
. "$Scripts\lib\ImportCSV.ps1"

#Breakout Systems
$PMO = ./scripts/lib/pmo.ps1
$SRV = ./scripts/lib/srv.ps1
$WS = ./scripts/lib/ws.ps1
$NONWIN = ./scripts/lib/nonwin.ps1

#Export Results
    $WS | Select IP, NetBIOSName, DNSName, AuditID, SevCode, IAV, Name, Description, Risk, FixInformation, OS, Exploit | sort NetBIOSName | export-csv "./MetricReports/Breakout/WS.csv" -NoTypeInformation
    $SRV | Select IP, NetBIOSName, DNSName, AuditID, SevCode, IAV, Name, Description, Risk, FixInformation, OS, Exploit | sort NetBIOSName | export-csv "./MetricReports/Breakout/SRV.csv" -NoTypeInformation
    $PMO | Select IP, NetBIOSName, DNSName, AuditID, SevCode, IAV, Name, Description, Risk, FixInformation, OS, Exploit | sort NetBIOSName | export-csv "./MetricReports/Breakout/PMO.csv" -NoTypeInformation
    $NonWin | Select IP, NetBIOSName, DNSName, AuditID, SevCode, IAV, Name, Description, Risk, FixInformation, OS, Exploit | sort NetBIOSName | export-csv "./MetricReports/Breakout/NonWin.csv" -NoTypeInformation

