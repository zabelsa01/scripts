#Get number of passwords less than 12 characters long
$passwordCSV | where-object {$_.password -ne "* empty *"} |where-object {$_.password -match '^.{1,11}$'} | measure

#Get number of passwords less than 12 characters long and set to never expire
$passwordCSV | where-object {$_.password -ne "* empty *"} |where-object {$_.password -match '^.{1,11}$'} | where-object {$_."never expires" -eq "x"}| measure

#Get number of passwords less than 12 characters long, set to never expire and not fe or adm accounts
$passwordCSV | where-object {$_.password -ne "* empty *"} |where-object {$_.password -match '^.{1,11}$'} | where-object {$_."never expires" -eq "x"}| where-object {$_.username -notlike "*.adm" -and $_.username -notmatch '^fe'} | measure

#get number of accounts with passwords less than 12 charcters and are enabled
$passwordCSV | where-object {$_.password -ne "* empty *"} |where-object {$_.password -match '^.{1,11}$'} | where-object {$_.disabled -ne "x"} | measure

#number of accounts with passwords less than 12 characters, enabled, and set to never expire
$passwordCSV | where-object {$_.password -ne "* empty *"} |where-object {$_.password -match '^.{1,11}$'} | where-object {$_.disabled -ne "x"} | where-object {$_."never expires" -eq "x"} |measure

#number of accounts set to never expire
$passwordCSV  |where-object {$_.password -ne ""} | where-object {$_."never expires" -eq "x"} | measure

#number of accounts enabled and password set to never expire
$passwordCSV |where-object {$_.password -ne ""} | where-object {$_.disabled -ne "x"} | where-object {$_."never expires" -eq "x"} |measure

#number of accounts with blank passwords
$passwordCSV  |where-object {$_.password -eq "* empty *"} | measure

#number of accounts with blank passwords and enabled
$passwordCSV  |where-object {$_.password -eq "* empty *"} |where-object {$_.disabled -ne "x"} | measure

#number of cracked adm accounts
$passwordCSV  |where-object {$_.password -ne ""} |where-object {$_.username -like "*.adm"} | measure

#number of cracked accounts using 16 character keyboard patterns
$passwordCSV  |where-object {$_.password -match '^.{16}'} | measure

#select passwords with 4 or more characters from same character set in a row
$passwordCSV  |where-object {$_.password -ne "* empty *"}|where-object {$_.password -cmatch '[A-Z]{4,}|[a-z]{4,}|[0-9]{4,}'} | select password
