#This script will enumerate all servers in the domain and set the "Log On To" value for the account to those servers
#Useful for stopping your domain admins from logging in to workstations with their accounts
#*** NOTE: The LogonWorkstations object can only hold 64 entries


import-module activedirectory
$userlist = "changeme-account1","changeme-account2"
$today = Get-Date
$cutoffdate = $today.AddDays(-60)
#Enumerate all servers
$serverarray = Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' -and LastLogonDate -gt $cutoffdate'} | Select -expand Name
#Example if you need to exclude servers by name
#$serverarray = Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' -and LastLogonDate -gt $cutoffdate -and Name -notlike 'startswith*'} | Select -expand Name
#LogonWorkstations requires a string, see: Get-Help Set-ADUser -Parameter LogonWorkstations
$serverlist = [string]::join(",",$serverarray)
foreach ($user in $userlist)
{
		Set-ADUser -Identity $user -LogonWorkstations $serverlist
}
