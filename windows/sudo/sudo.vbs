argc = WScript.Arguments.Count
Set argv = WScript.Arguments

If argc < 1 Then 
	WScript.quit
End If

Dim str
For i = 1 To argc-1
	str = str + " " + argv(i)
Next

Set objShell = CreateObject("Shell.Application") 
objShell.ShellExecute argv(0), str, "", "runas", 1