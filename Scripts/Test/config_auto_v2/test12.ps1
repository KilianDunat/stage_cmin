$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables): "
$regex2 = "^[1-2]$"

$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True}

if(($ou_ad -eq "1") -and ($networkAdapters.NetConnectionID -eq "Ethernetaze")){
    $choix_user = "Postes"
    $EthernetMAC = $EthernetMAC -replace ":", ""
    $newComputerName = "DESKTOP-" + ($EthernetMAC.Substring($EthernetMAC.Length-4))
}elseif(($ou_ad -eq "1") -and ($networkAdapters.NetConnectionID -eq "Wi-Fi")){
    $choix_user = "Postes"
    $WiFiMAC = $WiFiMAC -replace ":", ""
    $newComputerName = "DESKTOP-" + ($WiFiMAC.Substring($WiFiMAC.Length-4))
}
if(($ou_ad -eq "2") -and ($networkAdapters.NetConnectionID -eq "Ethernetaze")){
    $choix_user = "Portables"
    $EthernetMAC = $EthernetMAC -replace ":", ""
    $newComputerName = "LAPTOP-" + ($EthernetMAC.Substring($EthernetMAC.Length-4))
}elseif(($ou_ad -eq "2") -and ($networkAdapters.NetConnectionID -eq "Wi-Fi")){
    $choix_user = "Portables"
    $WiFiMAC = $WiFiMAC -replace ":", ""
    $newComputerName = "LAPTOP-" + ($WiFiMAC.Substring($WiFiMAC.Length-4))
}

$newComputerName | Write-Host