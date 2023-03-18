Start-Sleep -Seconds 45
#Write-Output "test" | Out-File -FilePath c:\log\test.log -Append
$date_heure = Get-Date
$firewall = Get-NetFirewallRule | where DisplayName -Like "cmin*" | where Group -Like $null
$computer = $env:COMPUTERNAME
$nbrrule = 0
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
$output | Out-File -FilePath \\storage.celieno.lan\commun\logfw\$computer.log -Append