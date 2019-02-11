<#
.SYNOPSIS
Quick and Dirty PoSh SQLite Query Function

.DESCRIPTION
Relies on sqlite3.exe from sqlite.org (https://sqlite.org/cli.html) because I'm too lazy to implement System.Data.SQLite. Assumes script, db, and client are in the same folder.

.PARAMETER Database
Enter the filename of a database to use. Ex: testdatabase.db

.PARAMETER QueryString
Enter a query. Ex: "SELECT * FROM Usernames"

.EXAMPLE
Invoke-SQLiteQuery usernames.db "SELCT * FROM Usernames"

.NOTES
Contact Information: https://github.com/BradyDonovan
#>

Function Invoke-SQLiteQuery {
    param (
        [parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the filename of a database to use. Ex: testdatabase.db")]
        [string]$Database,
        [parameter(Mandatory = $true, Position = 1, HelpMessage = "Enter a query. Ex: `"SELECT * FROM Usernames`"")]
        [string]$QueryString
    )
    begin {
        $ErrorActionPreference = 'Stop'
        
        #establish sqlite3.exe location
        Try {
            $clientLocation = Get-ChildItem "$PSScriptRoot\sqlite3.exe"
        }
        Catch {
            Throw "Could not locate client in current directory."
        }
        #establish database location
        Try {
            $databaseLocation = Get-ChildItem "$PSScriptRoot\$Database"
        }
        Catch {
            Throw "Could not locate database current directory."
        }
    }
    process {
        $queryInfo = New-Object System.Diagnostics.ProcessStartInfo
        $queryInfo.FileName = $clientLocation
        $queryInfo.RedirectStandardOutput = $true
        $queryInfo.UseShellExecute = $false
        $queryInfo.Arguments = "$databaseLocation `"$QueryString`""
        $queryProcess = New-Object System.Diagnostics.Process
        $queryProcess.StartInfo = $queryInfo
        $queryProcess.Start() | Out-Null
        $queryProcess.WaitForExit()
        $out = $queryProcess.StandardOutput.ReadToEnd()

        IF ($QueryString -like "*WHERE*") {
            $parseOut = ($out.Split("|"))
            foreach ($result in $parseOut) {
                "Column $($parseOut.IndexOf($result)) value: $result"
            }
        }
        ELSE {
            $out
        }
    }
}