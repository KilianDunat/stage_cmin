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
    Write-Host "Adresse MAC Ethernet: $EthernetMAC"
}
else {
    Write-Host "Aucune carte Ethernet détectée"
}

if ($WiFiMAC) {
    Write-Host "Adresse MAC WiFi: $WiFiMAC"
}
else {
    Write-Host "Aucune carte Wi-Fi détectée"
}
