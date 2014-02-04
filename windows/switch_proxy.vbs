Const HKCU=&H80000001 'HKEY_CURRENT_USER
Const HKLM=&H80000002 'HKEY_LOCAL_MACHINE

Const REG_SZ=1
Const REG_EXPAND_SZ=2
Const REG_BINARY=3
Const REG_DWORD=4
Const REG_MULTI_SZ=7

Const HKCU_IE_PROXY = "Software\Microsoft\Windows\CurrentVersion\Internet Settings"

Set oReg=GetObject("winmgmts:!root/default:StdRegProv")

Main

Sub Main()

' If Proxy is set then turn it off
If GetValue(HKCU,HKCU_IE_PROXY,"ProxyEnable",REG_DWORD) = 1 AND _
Len(GetValue(HKCU,HKCU_IE_PROXY,"ProxyServer",REG_SZ)) > 0 Then
CreateValue HKCU,HKCU_IE_PROXY,"ProxyEnable",0,REG_DWORD
wscript.echo "Proxy Disabled"
Else
' If Proxy is not set then turn it on

strProxyServer = "proxy:3128"
strProxyOveride = "<local>"

CreateValue HKCU,HKCU_IE_PROXY,"ProxyServer",strProxyServer,REG_SZ
CreateValue HKCU,HKCU_IE_PROXY,"ProxyEnable",1,REG_DWORD
CreateValue HKCU,HKCU_IE_PROXY,"ProxyOverride",strProxyOveride,REG_SZ
wscript.echo "Proxy Enabled" & vbcrlf & "(" & strProxyServer & ")"
End If

End Sub

Function CreateValue(Key,SubKey,ValueName,Value,KeyType)
Select Case KeyType
Case REG_SZ
CreateValue = oReg.SetStringValue(Key,SubKey,ValueName,Value)
Case REG_EXPAND_SZ
CreateValue = oReg.SetExpandedStringValue(Key,SubKey,ValueName,Value)
Case REG_BINARY
CreateValue = oReg.SetBinaryValue(Key,SubKey,ValueName,Value)
Case REG_DWORD
CreateValue = oReg.SetDWORDValue(Key,SubKey,ValueName,Value)
Case REG_MULTI_SZ
CreateValue = oReg.SetMultiStringValue(Key,SubKey,ValueName,Value)
End Select
End Function

Function DeleteValue(Key, SubKey, ValueName)
DeleteValue = oReg.DeleteValue(Key,SubKey,ValueName)
End Function

Function GetValue(Key, SubKey, ValueName, KeyType)

Dim Ret

Select Case KeyType
Case REG_SZ
oReg.GetStringValue Key, SubKey, ValueName, Value
Ret = Value
Case REG_EXPAND_SZ
oReg.GetExpandedStringValue Key, SubKey, ValueName, Value
Ret = Value
Case REG_BINARY
oReg.GetBinaryValue Key, SubKey, ValueName, Value
Ret = Value
Case REG_DWORD
oReg.GetDWORDValue Key, SubKey, ValueName, Value
Ret = Value
Case REG_MULTI_SZ
oReg.GetMultiStringValue Key, SubKey, ValueName, Value
Ret = Value
End Select

GetValue = Ret
End Function