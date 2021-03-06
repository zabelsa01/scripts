date
$homedir = "E:\Retina Metrics"
cd $homedir

function ScanCurrent {
    $arrImport = @(import-csv ".\RetinaRAWData\$filename1")
    $TotalIP = ($arrImport | select IP -unique | measure-object).count
    $arrImport = $arrImport | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}

#Total IP addresses
    #$TotalIP = ($arrImport | select IP -unique | measure-object).count 

#Group all IAVs    
    $IAV = $arrImport | select IAV | group IAV | select -expand name
    $IAV = $IAV | foreach {$_ -split ","} | sort

#IAVs under for current month
    foreach ($IAVs in $IAV) {
    write-host "IAV" $IAVs
    $OpenVul = ($arrImport | where-object {$_.IAV -eq "$IAVs"} | select -expand IP -unique | measure-object).count
    write-host "Openvul" $OpenVul
    [int]$Percent = "{0:N2}" -f ((($TotalIP - $OpenVul)/$TotalIP)*100)
    write-host "Percent" $Percent    
        $arrPercent = @()
        if ($percent -lt 80) {    
        
            #Loop Through Previous Scans
                foreach ($fileselects in $fileselect) {
                write-host "File" $fileselects
                $arrImport2 = @(import-csv ".\RetinaRAWData\$fileselects")
                $arrImport2 = $arrImport2 | where-object {$_.IAV -ne "N/A"} | where-object {$_.IAV -notlike "*-T-*"} | where-object {$_.IAV -notlike "*-B-*"}
                $TotalIP2 = ($arrImport2 | select IP -unique | measure-object).count 
                write-host "total ip2" $totalip2
                $OpenVul2 = ($arrImport2 | where-object {$_.IAV -eq "$IAVs"} | select -expand IP -unique | measure-object).count
                write-host "openvul 2" $openvul2
                if ($OpenVul2 -eq 0) {$OpenVul2 = $TotalIP2}
                $Percent2 = "{0:N2}" -f ((($TotalIP2 - $OpenVul2)/$TotalIP2)*100)
                write-host "percent 2" $percent2
                [array]$arrPercent = $arrPercent + [int]$Percent2
                write-host "percent array" $arrPercent           
                                                       }
                        $IAVs+","+$arrPercent[0]+","+$arrPercent[1]+","+$arrPercent[2]+","+$arrPercent[3]+","+$arrPercent[4]+","+$Percent >> $csvfile                
                            }
                              }
}

#CSV Creation
    $filename1 = ls ./RetinaRAWData/*.csv | sort creationtime -descending | select -first 1 | sort creationtime  | select -expand Name
    $fileselect = ls ./RetinaRAWData/*.csv | sort creationtime -descending | select -first 6 | sort creationtime | select -expand name
    $fileselect = $fileselect | where-object {$_ -notlike "*$filename1*"}
    $csvfile = "./tmp/temp.txt"
    $a = "IAV"+","+$fileselect[0]+","+$fileselect[1]+","+$fileselect[2]+","+$fileselect[3]+","+$fileselect[4]+","+$filename1
    $a > $csvfile

#Run Funcions
    ScanCurrent
    import-csv $csvfile | export-csv ./MetricReports/ICVATracker.csv -NoTypeInformation
    del $csvfile
    date
