# Unix Cal Command ( Get-Cal.ps1 )

Param(
	[Int]$Year=(Get-Date).Year,
	[Int]$Month=(Get-Date).Month,
	[Switch] $Next,
	[Switch] $Previous,
	[Switch] $WholeYear
)

$script:err=$false
if ($Next) {
	$Month=((Get-Date).Month+1)
	if ($Month -eq 13) {
		$Year=(Get-Date).Year+1
		$Month=1
	}
}

if ($Previous) {
	$Month=((Get-Date).Month-1)
	if ($Month -eq 0) {
		$Year=(Get-Date).Year-1
		$Month=12;
	}
}

$Space=" "
# trap { Write-Host -f red "Exception occurred while parsing month/year parameters.";$script:err=$true;continue}

$StartMonth = $Month
$EndMonth = $Month
if ($WholeYear) {
	$StartMonth = 1
	$EndMonth = 12
}

$StartMonth..$EndMonth | foreach {
	$Month = $_
	$StartDate=new-object System.DateTime $Year,$Month,1
	if ($script:err) {
		return;
	}

	$MonthLabel="$($StartDate.ToString("MMMM")) $($StartDate.Year)"
	$AlignCenter=[Math]::Ceiling((20-$MonthLabel.Length)/2)
	write-host "`n$($Space * $AlignCenter)$MonthLabel`n"

	# [culture-aware]
	$DOWLabel0 = [System.Globalization.CultureInfo]::get_CurrentCulture().datetimeformat.shortestdaynames
	$i = $first = [int][System.Globalization.CultureInfo]::get_CurrentCulture().datetimeformat.firstdayofweek
	$DowLabel = @()
	1..7 | foreach {
		$DowLabel += $DowLabel0[$i]
		$i = ($i+1) % 7
	}
	# [/culture-aware]

	Write-Host "$DOWLabel"
	$NextDate = $StartDate

	# [culture-aware]
	$SpaceCount = (([int]$StartDate.DayOfWeek - $first))*3
	if ($SpaceCount -lt 0) {
		$SpaceCount += 21
	}
	# [/culture-aware]

	Write-Host $($Space * $SpaceCount) -No
	While ($NextDate.Month -eq $StartDate.Month) {
		if ($NextDate.ToString("MMddyyyy") -eq $(get-date).ToString("MMddyyyy")) {
			Write-Host ("{0,2}" -f $NextDate.Day) -no -fore yellow
		} else {
			Write-Host ("{0,2}" -f $NextDate.Day) -no
		}

		Write-Host " " -No
		$NextDate=$NextDate.AddDays(1)

		# [culture-aware]
		if ([int]$NextDate.DayOfWeek -eq $first)
		# [/culture-aware]
		{
			Write-Host
		}
	}
	
	write-host "`n"
}


