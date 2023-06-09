﻿$list_group = 'assistance','commercial','administratif','tv'

foreach($group in $list_group){
    if (@(Get-ADGroup -Filter {sAMAccountName -eq $group}).Count -eq 0)
    {
      Write-Error -Message "Le groupe $group n'existe pas." -ErrorAction Stop
    }
}

$groups = $list_group | ForEach-Object { Get-ADGroup -Filter "Name -eq '$_'" } | Select-Object -Expand DistinguishedName

Get-aduser -Filter * -Property cn, memberof| Where-Object {
  -not (Compare-Object $groups $_.memberof -IncludeEqual -ExcludeDifferent)
} | Select-Object cn, distinguishedName | Export-Csv .\list_user_notmember.csv -notype -Encoding UTF8 -Delimiter ';' -Force