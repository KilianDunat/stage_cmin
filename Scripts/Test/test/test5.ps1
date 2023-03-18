#$Computer = Get-ADComputer -Filter *

Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -Properties msfve-recoverypassword