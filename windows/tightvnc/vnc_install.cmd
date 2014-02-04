tvnserver -install -silent
start /wait MirrInst.exe
netsh firewall add portopening tcp 5900 vnc enable all
tvnserver -start -silent
reg import vnc.reg
tvnserver -controlservice -reload
