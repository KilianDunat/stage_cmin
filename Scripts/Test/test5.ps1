Import-Module ActiveDirectory
$groupname = "TempGroup"
$excludegroup1 = "Group1"
$excludegroup2 = "Group2"
$excludegroup2 = "Group4"
$excludegroup2 = "Group4"
$users = Get-ADUser -Filter * -SearchBase "ou=xxx,dc=xxx,dc=xxx" -SearchScope Subtree
foreach($user in $users)
{
  Get-ADGroupMember -Identity $groupname -Member $user.samaccountname -ErrorAction SilentlyContinue
}
$members = Get-ADGroupMember -Identity $groupname
$excludemembers = Get-ADGroupMember -Identity $excludegroup1
foreach($member in $excludemembers)
{
 Remove-ADGroupMember -Identity $groupname -Member $member.samaccountname
}
$members = Get-ADGroupMember -Identity $groupname
$excludemembers = Get-ADGroupMember -Identity $excludegroup2
foreach($member in $excludemembers)
{
 Remove-ADGroupMember -Identity $groupname -Member $member.samaccountname
}
$members = Get-ADGroupMember -Identity $groupname
$excludemembers = Get-ADGroupMember -Identity $excludegroup3
foreach($member in $excludemembers)
{
 Remove-ADGroupMember -Identity $groupname -Member $member.samaccountname
}
$members = Get-ADGroupMember -Identity $groupname
$excludemembers = Get-ADGroupMember -Identity $excludegroup4
foreach($member in $excludemembers)
{
 Remove-ADGroupMember -Identity $groupname -Member $member.samaccountname
}