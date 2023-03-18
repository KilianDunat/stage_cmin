Get-Date | Out-File -FilePath ./recovery_key_bitlocker_ad.csv
$Computers = Get-ADComputer -Filter *

foreach ($Computer in $Computers) {
    #$Computer.Name | Write-Host 
    #$Computer.DistinguishedName | Write-Host 
    $BitLockerObjects=(Get-ADObject -SearchBase $Computer.DistinguishedName -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -Properties msFVE-RecoveryGuid, msFVE-RecoveryPassword)
    #$BitLockerObjects | Out-File -FilePath ./test.csv

    foreach ($BitLockerObject in $BitLockerObjects) {
    
        $strComputerDate = $BitLockerObject.Name.Substring(0,25)
        #$strComputerTime = $BitLockerObject.Name.Substring(11,8)
        #$strComputerPasswordID = $BitLockerObject.Name.Substring(26,36)
        $strComputerPasswordID = $BitLockerObject.'msFVE-RecoveryGuid'
        $total = New-Object Guid @(,$strComputerPasswordID)
        $strComputerRecoveryPassword = $BitLockerObject.'msFVE-RecoveryPassword'
    
        $strToReport = $Computer.Name + "; " + $strComputerDate + "; " + $total.ToString("D").ToUpper() + "; " + $strComputerRecoveryPassword + "; " + $Computer.DistinguishedName
        
        $strToReport | Out-File -FilePath ./recovery_key_bitlocker_ad.csv -Append
    }

}