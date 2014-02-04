Import-Module ActiveDirectory

function Get-ADUserName([string]$userName)
{
	$dcs = Get-ADDomainController -Filter {Name -like "*"}

	foreach($dc in $dcs)
	{ 
		$user = Get-ADUser $userName | Get-ADObject -Properties displayName 
	}
	
	$user = $user -replace "CN=",""
	$user = $user -split ","

	Write-Host $user[0]
}

foreach ($i in $input)
{
	Get-ADUserName -userName $i
}
