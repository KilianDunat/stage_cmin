$date_heure = Get-Date
$firewall = Get-NetFirewallRule | where DisplayName -Like "cmin*" | where Group -Like $null
$computer = $env:COMPUTERNAME
$nbrrule = 0
$test = 0
$haserror = $false
$output = "$date_heure - $($firewall.Count) rules found on $computer."

foreach ($rule in $firewall) {
    try {
    Remove-NetFirewallRule -DisplayName $rule.DisplayName -ErrorAction stop
    $nbrrule ++
    $output += " rule $($rule.DisplayName) deleted."
    }
    catch {
    $output += " error : $($_.Exception.Message)"
    }
}

$output += " $nbrrule rules deleted."

while ($test -lt 10) {
    try {
    $output | Out-File -FilePath \\storage.celieno.lan\commun\logfw\$computer.log -Append
    break
    }
    catch {
    if(!$haserror){
        $output += " error : $($_.Exception.Message)"
        $haserror = $true
        }
    }
    $test ++
    Start-Sleep -seconds 2
}

#$output | Out-File -FilePath c:\log\test.log -Append
#$test | Out-File -FilePath c:\log\test.log -Append

#$output | Out-File -FilePath \\storage.celieno.lan\commun\logfw\$computer.log -Append