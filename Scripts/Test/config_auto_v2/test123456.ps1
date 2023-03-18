$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables): "
$regex2 = "^[1-2]$"

$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True}

$EthernetMAC = $null
$WiFiMAC = $null

foreach ($networkAdapter in $networkAdapters) {
    if ($networkAdapter.NetConnectionID -eq "Ethernet" -and $networkAdapter.MACAddress) {
        $EthernetMAC = $networkAdapter.MACAddress
        break
    }
    if ($networkAdapter.NetConnectionID -eq "Wi-Fi" -and !$EthernetMAC -and $networkAdapter.MACAddress) {
        $WiFiMAC = $networkAdapter.MACAddress
    }
}

if ($ou_ad -eq "1") {
    $choix_user = "Postes"
} else {
    $choix_user = "Portables"
}

if ($EthernetMAC) {
    $newComputerName = $choix_user + "-" + ($EthernetMAC -replace ":", "").Substring($EthernetMAC.Length-4)
} elseif ($WiFiMAC) {
    $newComputerName = $choix_user + "-" + ($WiFiMAC -replace ":", "").Substring($WiFiMAC.Length-4)
}
