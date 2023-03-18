$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $True}

foreach ($adapter in $networkAdapters) {
    if ($adapter.Description -like "*Ethernet*") {
        $EthernetMAC = $adapter.MACAddress
    }
    elseif ($adapter.Description -like "*Wi-Fi*") {
        $WiFiMAC = $adapter.MACAddress
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
