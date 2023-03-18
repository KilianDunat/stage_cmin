$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables): "
$regex = "^[1-2]$"

if (!($ou_ad -match $regex)) {
    Write-Host "Entrée non valide, veuillez réessayer."
    return
}

$ethernetAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and $_.NetConnectionID -eq "Ethernet"} | Select-Object -First 1
$wiFiAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and $_.NetConnectionID -eq "Wi-Fi"} | Select-Object -First 1

if ($ethernetAdapter) {
    $mac = $ethernetAdapter.MACAddress -replace ":", ""
} elseif ($wiFiAdapter) {
    $mac = $wiFiAdapter.MACAddress -replace ":", ""
} else {
    Write-Host "Aucun adaptateur réseau Ethernet ou Wi-Fi trouvé."
    return
}

$newComputerName = if ($ou_ad -eq "1") { "DESKTOP-" } else { "LAPTOP-" } + $mac.Substring($mac.Length - 4)
