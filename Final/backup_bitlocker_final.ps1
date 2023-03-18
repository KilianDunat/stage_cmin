$result = manage-bde -protectors -get c: -type recoverypassword
$id = $result -match "ID" | Out-String
$id = $id.Substring(11)
$revid = $id -replace "`t|`n|`r",""
$finalid = "`"" + $revid + "`""
manage-bde -protectors -adbackup c: -id $finalid