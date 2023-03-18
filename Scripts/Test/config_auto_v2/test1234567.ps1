$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables)"
$regex2 = "^[1-2]$"

$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True}

foreach ($adapter in $networkAdapters) {
    if ($adapter.NetConnectionID -eq "Ethernet") {
        $EthernetMAC = $adapter.MACAddress
        break
    }
    elseif ($adapter.NetConnectionID -eq "Wi-Fi") {
        $WiFiMAC = $adapter.MACAddress
        break
    }
}

if (($EthernetMAC) -and  ($ou_ad -eq "1")){
    $EthernetMAC = $EthernetMAC -replace ":", ""
    $newComputerName = "laptop-" + ($EthernetMAC.Substring($EthernetMAC.Length-4))
}
elseif (($WiFiMAC) -and ($ou_ad -eq "2")){
    $WiFiMAC = $WiFiMAC -replace ":", ""
    $newComputerName = "laptop-" + ($WiFiMAC.Substring($WiFiMAC.Length-4))
}

$newComputerName | Write-Host