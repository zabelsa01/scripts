[CmdletBinding()]
param (
	[Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$True)]
	[string]$target
)

BEGIN {
	
	Function Get-DnsEntry ($iphost) {
		If ($ipHost -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
			[System.Net.Dns]::GetHostEntry($iphost).HostName
		}
		ElseIf ( $ipHost -match "^.*\.\.*") {
			[System.Net.Dns]::GetHostEntry($iphost).AddressList[0].IPAddressToString
		} else { 
			Throw "Specify either an IP V4 address or a hostname" 
		}
	} #end Get-DnsEntry
	
	$Searcher = New-Object DirectoryServices.DirectorySearcher
	$n = 0
}

PROCESS {
	$n += 1
	# Check null or empty
	if (($target -eq $null) -OR ($Target -eq '')) {
		Write-Verbose "$target is null"
		continue
	}
	
	$Output = new-Object PSObject -Property @{
		Hostname 	= $null
		IP			= $null
		OS			= $null
	}
	
	if ($target -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
		# IP Address input, reverse DNS lookup for hostname
		$Output.IP = $Target
		try {
			$Output.Hostname = (Get-DnsEntry $Target).ToString()
		} catch {
			Write-Verbose "($n): $Target would not resolve"	
			$Output.Hostname = $null
		}
		
	} else {
		# Hostname Input, DNS Loopup for IP Address
		$Output.Hostname = $Target
		try {
			$Output.IP = (Get-DnsEntry "$Target.AREA52.AFNOAPPS.USAF.MIL").ToString()
		} catch {
			Write-Verbose "($n): $Target would not resolve"	
			$Output.IP = $Null
		}
	}
	
	# Get OS
	if ($Output.Hostname -ne $null) {
		# $Searcher = New-Object DirectoryServices.DirectorySearcher
		$comp = $Output.Hostname
		Write-Verbose "Getting OS from $comp"
		$Searcher.Filter = "(&(objectClass=computer)(cn=$comp))"
		$Comp_LDAP = $Searcher.Findone()
		$Output.OS = ($Comp_LDAP.properties.operatingsystem | out-string).Trim()
		#$Output.OS = ([adsi]$Comp_LDAP.Path).operatingSystem
		Write-Verbose "$Output"
	} else { 
		Write-Verbose "Could not get OS.  Hostname did not resolve."
	}
	
	# Output
	Write-Output $Output
}

END {}
