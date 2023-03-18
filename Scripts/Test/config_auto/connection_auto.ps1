Write-Host "veuillez vous connecter à internet pour que le script fonctionne."

#$namecomputer = Read-Host "Entrer le nouveau nom de l'ordinateur: "
$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables): "
#$regex = "^[A-Z0-9-]{5,15}$"
$regex2 = "^[1-2]$"

<#while ($namecomputer -notmatch $regex) {
    Write-Host "Le nom de l'ordinateur ne respecte pas les caractères autorisés (majuscule, chiffre et tiret). Veuillez entrer un nom valide :"
    $namecomputer = Read-Host
}#>

$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True}

<#foreach ($adapter in $networkAdapters) {
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
elseif ($WiFiMAC) {
    $WiFiMAC = $WiFiMAC -replace ":", ""
    $newComputerName = "laptop-" + ($WiFiMAC.Substring($WiFiMAC.Length-4))}
#>

if(($ou_ad -eq "1") -and ($networkAdapters.NetConnectionID -eq "Ethernet")){
    $choix_user = "Postes"
    $EthernetMAC = $EthernetMAC -replace ":", ""
    $newComputerName = "DESKTOP-" + ($EthernetMAC.Substring($EthernetMAC.Length-4))
}elseif(($ou_ad -eq "1") -and ($networkAdapters.NetConnectionID -eq "Wi-Fi")){
    $choix_user = "Postes"
    $WiFiMAC = $WiFiMAC -replace ":", ""
    $newComputerName = "DESKTOP-" + ($WiFiMAC.Substring($WiFiMAC.Length-4))
}
if(($ou_ad -eq "2") -and ($networkAdapters.NetConnectionID -eq "Ethernet")){
    $choix_user = "Portables"
    $EthernetMAC = $EthernetMAC -replace ":", ""
    $newComputerName = "LAPTOP-" + ($EthernetMAC.Substring($EthernetMAC.Length-4))
}elseif(($ou_ad -eq "2") -and ($networkAdapters.NetConnectionID -eq "Wi-Fi")){
    $choix_user = "Portables"
    $WiFiMAC = $WiFiMAC -replace ":", ""
    $newComputerName = "LAPTOP-" + ($WiFiMAC.Substring($WiFiMAC.Length-4))
}

Rename-Computer -NewName $namecomputer

$connected = $false
while (-not $connected) {
    $internetCheck = Test-Connection -ComputerName celieno.lan -Count 1 -Quiet
    if ($internetCheck) {
        $route = Get-NetRoute -DestinationPrefix 0.0.0.0/0
        While($route -eq $null) {
            delete route 0.0.0.0
        }

        Add-Computer -DomainName "celieno.lan" -OUPath "OU=$choix_user,OU=Ordinateurs,DC=celieno,DC=lan"

        Restart-Computer
        $connected = $true
    } else {
        Write-Host "L'ordinateur n'est pas connecté à Internet, le script s'exécutera à nouveau dans 5 secondes."
        Start-Sleep -Seconds 5
    }
}
