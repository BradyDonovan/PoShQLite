# PoShQLite
Quick and Dirty PoSh SQLite Query Function

Works by using sqlite3.exe and sending query results to STDOUT. 

Command-line client can be downloaded from here: https://sqlite.org/download.html

Usage:
```powershell
. .\Invoke-SQLiteQuery.ps1
Invoke-SQLiteQuery usernames.db "SELCT * FROM Usernames"
```
