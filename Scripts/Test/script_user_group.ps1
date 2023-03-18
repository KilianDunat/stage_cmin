$users = Get-ADUser -Filter * -SearchBase "DC=celieno,DC=lan" -Properties * | Select-Object -ExpandProperty sAMAccountName

$groups = "assistance","commercial"

foreach ($user in $users) {
    foreach ($group in $groups) {
        $members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SamAccountName

        If ($members -notcontains $user -and $members -eq 2) {
            Write-Host "$user is a  not member of multi group"
        }
    }
}