$date_heure = Get-Date
$computer = $env:COMPUTERNAME
$test = 0
$haserror = $false
$output = "$date_heure - "
$output += [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$output | Out-File -FilePath c:\$computer.log -Append

while ($test -lt 10) {
    try {
    $output | Out-File -FilePath \\storage.celieno.lan\test\xxx$computer.log -Append
    break
    }
    catch {
    if(!$haserror){
        $output += " - error : $($_.Exception.Message)"
        $haserror = $true
        }
    }
    $test ++
    #Start-Sleep -seconds 2
}

$output | Out-File -FilePath c:\$computer.log -Append
#$test | Out-File -FilePath c:\log\test.log -Append

#$output | Out-File -FilePath \\storage.celieno.lan\commun\logfw\$computer.log -Append