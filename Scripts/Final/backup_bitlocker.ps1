$ADBegup = Get-BitLockerVolume -MountPoint "C:"
Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $ADBegup.KeyProtector[1].KeyProtectorId

#$ADBegup | Export-Csv .\test.csv -notype -Encoding UTF8 -Delimiter ',' -Force