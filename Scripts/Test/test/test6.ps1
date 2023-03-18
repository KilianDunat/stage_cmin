Get-AdObject -Filter "objectclass -eq 'msFVE-RecoveryInformation'" -Properties DistinguishedName, msFVE-RecoveryGuid, msFVE-RecoveryPassword, WhenCreated |
Select-Object -Property @{n="ComputerName";e={$_.DistinguishedName.Split(',',2)[1]}}, msFVE-RecoveryPassword
#$strComputerPasswordID = $BitLockerObject.'msFVE-RecoveryGuid'
#$total = New-Object Guid @(,$strComputerPasswordID)

Select-Object -Property @{n="ComputerName";e={$_.DistinguishedName.Split(',',2)[1]}}, msFVE-RecoveryPassword #, $total.ToString("D").ToUpper()