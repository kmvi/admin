' Смена маски подсети
Option Explicit
On Error Resume Next

Dim objWMIService
Dim objNetAdapter
Dim arrIPAddress
Dim arrSubnetMask
Dim colNetAdapters
Dim errEnableStatic

' Новая маска подсети
arrSubnetMask = Array("255.255.252.0")

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colNetAdapters = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE")

errEnableStatic = -1

For Each objNetAdapter in colNetAdapters
	If Mid(objNetAdapter.IPAddress(0), 0, 4) = "192." Then
		arrIPAddress = Array(objNetAdapter.IPAddress(0))
		errEnableStatic = objNetAdapter.EnableStatic(arrIPAddress, arrSubnetMask)
	End If
Next

return errEnableStatic

