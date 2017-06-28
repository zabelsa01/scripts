# Variables
$HashProvider = new-object -TypeName system.security.cryptography.MD5CryptoServiceProvider;

function Hash-File ([string]$inputStr, $Provider=$HashProvider, [int]$inputType=1) {
	# Perform MD5 hash on item
	#
	# @param input		Input to hash
	# @param Provider	Type of hashing to conduct.  MD5 (Default); SHA-1;
	# @param inputType	Type of input.  0 = string ; 1 = file name (Default)
	#
	# @returns			[string] hash of input, uppercase hex without byte group delimiters
	
	
	if ($inputType -eq 1) {
		if (($inputStr -eq '') -or ($inputStr -eq $null)) {
			Write-Error "Hash Error: Input String was Null or Empty"
			return '';
		}
        try {
			$inputBytes = [System.IO.File]::ReadAllBytes($inputStr);
	    } catch {
			Write-Error "String: $inputStr"
			Write-Error "Hash Error: Could not read raw bytes of file"
			return '';  
        }
    } else {
		try {
			$inputBytes = [System.Text.Encoding]::UTF8.GetBytes($inputStr);
	    } catch {
			Write-Error "Hash Error: Could not convert string to bytes"
			Write-Error "String: $inputStr"
			return '';  
        }
	}
	try {
		$result2 = [System.BitConverter]::ToString($Provider.ComputeHash($inputBytes))
		$result = $result2.Replace('-','').ToUpper()
	} catch {
		Write-Error "String: $inputStr"
		Write-Error "Hash Error: Could not compute Hash"
		return ''; 		
	}
	return $result;
}


function Parse-CLPath ([string]$inputStr) {
	# PathName extractor
	#[regex]$pathpattern = '(\b[a-z]:\\(?# Drive)(?:[^\\/:*?"<>|\r\n]+\\)*)(?# Folder)([^\\/:*?"<>|\r\n,\s]*)(?# File)'
	#[regex]$pathpattern = "((?:(?:%\w+%\\)|(?:[a-z]:\\)){1}(?:[^\\/:*?""<>|\r\n]+\\)*[^\\/:*?""<>|\r\n]*\.(?:exe|dll|sys))"
	
	#Check for paths with no drive letter:
	$str = $inputStr.ToLower()
	
	if ($str -match "%systemroot%") {
		$str = $str.Replace("%systemroot%", "$env:SystemRoot")
	}
	if ($str -match "%programfiles%") {
		$str = $str.Replace("%programfiles%", "$env:programfiles")
	}
	if ($str -match "%windir%") {
		$str = $str.Replace("%windir%", "$env:windir")
	}	
	if ($str -match "\\systemroot") {
		$str = $str.Replace("\systemroot", "$env:SystemRoot")
	}

	if ($str.StartsWith("system32")) {
		$str = $env:windir + "\" + $str
	}
	if ($str.StartsWith("syswow64")) {
		$str = $env:SystemRoot + "\" + $str
	}

	# Match Regex of File Path
	$regex = '(\b[a-z]:\\(?# Drive)(?:[^\\/:*?"<>|\r\n]+\\)*)(?# Folder)([^\\/:*?"<>|\r\n,\s]*)(?# File)'
	$matches = $str | select-string -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value }
	
	# Write-Verbose "Matches: $str --> $matches"
	
	return $matches
}


function Convert-BinaryToString {
    [CmdletBinding()]
    param (
        [string] $FilePath
    )

	# $Content = Get-Content -Path $FilePath -Encoding Byte
	# $Base64 = [System.Convert]::ToBase64String($Content)
	# $Base64 | Out-File $FilePath.txt
	# http://trevorsullivan.net/2012/07/24/powershell-embed-binary-data-in-your-script/
	
    try {
        $ByteArray = [System.IO.File]::ReadAllBytes($FilePath);
    }
    catch {
        throw "Failed to read file. Please ensure that you have permission to the file, and that the file path is correct.";
    }

    if ($ByteArray) {
        $Base64String = [System.Convert]::ToBase64String($ByteArray);
    }
    else {
        throw '$ByteArray is $null.';
    }

    Write-Output -InputObject $Base64String;
}


function Convert-StringToBinary {
    [CmdletBinding()]
    param (
          [string] $InputString
        , [string] $FilePath = ('{0}\{1}' -f $env:TEMP, [System.Guid]::NewGuid().ToString())
    )
	# $TargetFile = Convert-StringToBinary -InputString $NewExe -FilePath C:\temp\new.exe;
	# Start-Process -FilePath $TargetFile.FullName;
	# http://trevorsullivan.net/2012/07/24/powershell-embed-binary-data-in-your-script/
	
    try {
        if ($InputString.Length -ge 1) {
            $ByteArray = [System.Convert]::FromBase64String($InputString);
            [System.IO.File]::WriteAllBytes($FilePath, $ByteArray);
        }
    }
    catch {
        throw ('Failed to create file from Base64 string: {0}' -f $FilePath);
    }

    Write-Output -InputObject (Get-Item -Path $FilePath);
}


