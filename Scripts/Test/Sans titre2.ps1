﻿(Get-ADUser -Filter * | Select-Object Name, distinguishedName).count