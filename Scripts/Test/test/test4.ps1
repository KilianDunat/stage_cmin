$Computers = Get-ADComputer -Filter *

foreach ($Computer in $Computers) {

    $BitLockerObjects=(Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -Properties msFVE-RecoveryPassword)
    
    $BitLockerObjects | Out-File -FilePath ./test.log

    foreach ($BitLockerObject in $BitLockerObjects) {
    
        $strComputerDate = $BitLockerObject.Name.Substring(0,10)
        $strComputerTime = $BitLockerObject.Name.Substring(11,8)
        $strComputerGMT = $BitLockerObject.Name.Substring(19,6)
        $strComputerPasswordID = $BitLockerObject.Name.Substring(26,36)
        $strComputerRecoveryPassword = $BitLockerObject.'msFVE-RecoveryPassword'
    
        $strToReport = $Computer.Name + $strDelimiter + $Computer.OperatingSystem + $strDelimiter + $strComputerDate + $strDelimiter + $strComputerTime + $strDelimiter + $strComputerGMT + $strDelimiter + $strComputerPasswordID + $strDelimiter + $strComputerRecoveryPassword + $strDelimiter + $Computer.DistinguishedName
        
        #$strToReport | Out-File -FilePath ./test.log  
    }

}