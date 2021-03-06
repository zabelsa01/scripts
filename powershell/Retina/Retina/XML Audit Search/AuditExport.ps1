# Need to run as Admin

$auditloc = "E:\eEye Retina\Database"
$exportloc = "E:\Retina Metrics\Scripts\Audit Export"
$dat = get-date -uformat "%m%d%Y"
cd $auditloc

[xml]$a = gc $auditloc\audits.xml
$id = $a.selectnodes("/audits/rth")
$a = (clear-variable [xml]$a)
$results = foreach ($i in $id) {$i.selectsinglenode("checkdata/checkdatum") | select @{Name="id"; Expression = {$i | select -expand id}}, @{Name="name"; Expression = {$i | select -expand name}}, @{Name="desc"; Expression = {$i | select -expand description}}, os,code,checktype,data}
$results | export-csv $exportloc\AllAudits-$dat.csv -NoTypeInformation
cp "$explortloc\AllAudits-$dat.csv" "\\Path\1-Retina Data\Audit Lookup\"