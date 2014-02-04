@ECHO OFF
robocopy d:\srcfolder\ \\srv\backup\destfolder\ /mir /copyall /r:0 /dcopy:t /tee /log:d:\srcfolder\backup.log /np /v /ns /nc /nfl /ndl
