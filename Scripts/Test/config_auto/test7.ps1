$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True}

#$networkAdapters.netConnectionID | Write-Host

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

if ($EthernetMAC) {
    $EthernetMAC = $EthernetMAC -replace ":", ""
    $newComputerName = "laptop-" + ($EthernetMAC.Substring($EthernetMAC.Length-4))
}
else {
    Write-Host "Aucune carte Ethernet détectée"
}

if ($WiFiMAC) {
    $WiFiMAC = $WiFiMAC -replace ":", ""
    $newComputerName = "laptop-" + ($WiFiMAC.Substring($WiFiMAC.Length-4))

}
else {
    Write-Host "Aucune carte Wi-Fi détectée"
}

$EthernetMAC | Write-Host
$WiFiMAC | Write-Host
$newComputerName | Write-Host