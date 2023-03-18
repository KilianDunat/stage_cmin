﻿Get-ADUser -Filter * -SearchBase "OU=admin,DC=celieno,DC=lan" -Properties PasswordLastSet, PasswordNeverExpires, msDS-ResultantPSO | Select-Object Name, PasswordLastSet, PasswordNeverExpires, distinguishedName, msDS-ResultantPSO | Export-Csv .\compte_priviligies.csv -notype -Encoding UTF8 -Delimiter ',' -Force