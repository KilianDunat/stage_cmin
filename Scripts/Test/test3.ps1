$groups = @("assistance","commercial")
foreach ($groups1 in $groups) {
    $group = (Get-ADGroup $groups1).DistinguishedName
    Get-ADUser -LDAPFilter "(!(memberof=$group))" -Properties * | 
    select-object Name, SamAccountName, EmailAddress, msExchMailboxGuid
}