$date_heure = Get-Date
$firewall = Get-NetFirewallRule | where DisplayName -Like "cmin*" | where Group -Like $null
$computer = $env:COMPUTERNAME
$nbrrule = 0
$tries = 1
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

while ($tries -le 30) {
    try {
    $output2 = $output + " (Tries $($tries))"
    $output2 | Out-File -FilePath \\storage.celieno.lan\commun\logfw\$computer.log -Append
    break
    }
    catch {
    if(!$haserror){
    #$output += " error : $($_.Exception.Message)"
        $haserror = $true
        }
    }
    $tries ++
    Start-Sleep -seconds 2
}

#$output | Out-File -FilePath c:\$computer.log -Append
