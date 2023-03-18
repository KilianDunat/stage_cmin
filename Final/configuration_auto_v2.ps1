Write-Host "Veuillez-vous connecter à internet pour que le script fonctionne."

#$namecomputer = Read-Host "Entrer le nouveau nom de l'ordinateur: "
$ou_ad = Read-Host "Veuillez choisir quel ordinateur c'est (1: Ordinateur de bureau ou 2: Ordinateur portable)"
#$regex = "^[A-Z0-9-]{5,15}$"
$regex2 = "^[1-2]$"

<#while ($namecomputer -notmatch $regex) {
    Write-Host "Le nom de l'ordinateur ne respecte pas les caractères autorisés (majuscule, chiffre et tiret). Veuillez entrer un nom valide :"
    $namecomputer = Read-Host
}#>

while (!($ou_ad -match $regex2)) {
    Write-Host "Entrée non valide, veuillez choisir seulement 1 ou 2."
    return
}

$ethernetAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and $_.NetConnectionID -eq "Ethernet"} #| Select-Object -First 1
if ($ethernetAdapter) {
    $mac = $ethernetAdapter.MACAddress -replace ":", ""
} else {
    $networkAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and $_.NetConnectionID -eq "Wi-Fi"} #| Select-Object -First 1
    $mac = $networkAdapter.MACAddress -replace ":", ""
    if (!$networkAdapter) {
        Write-Host "Aucun adaptateur réseau Ethernet ou Wi-Fi trouvé."
        return
    }
}

$newComputerName = if ($ou_ad -eq "1") {
    $choix_user = "Postes"
    "DESKTOP-" + $mac.Substring($mac.Length - 4)
} else {
    $choix_user = "Portables"
    "LAPTOP-" + $mac.Substring($mac.Length - 4)
}

<#$networkAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and ($_.NetConnectionID -eq "Ethernet" -or $_.NetConnectionID -eq "Wi-Fi")} | Select-Object -First 1
if (!$networkAdapter) {
    Write-Host "Aucun adaptateur réseau Ethernet ou Wi-Fi trouvé."
    return
}

$mac = $networkAdapter.MACAddress -replace ":", ""
$newComputerName = if ($ou_ad -eq "1") {
    $choix_user = "Postes"
    "DESKTOP-" + $mac.Substring($mac.Length - 4)
} else {
    $choix_user = "Portables"
    "LAPTOP-" + $mac.Substring($mac.Length - 4)
}#>

#$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True}

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

<#if(($ou_ad -eq "1") -and ($networkAdapters.NetConnectionID -eq "Ethernet")){
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
}#>

Write-Host "Résumé des actions à venir :"
Write-Host "OU AD choisie : OU=$choix_user,OU=Ordinateurs,DC=celieno,DC=lan"
Write-Host "Nouveau nom de l'ordinateur : $newComputerName"
Write-Host "Connexion au domaine : celieno.lan"
Write-Host "Redémarrage de l'ordinateur pour appliquer les modifications."

$confirm = Read-Host "Veuillez vérifier les informations ci-dessus et tapez 'Y' pour continuer, toute autre entrée pour annuler"
if ($confirm -eq "Y") {
    $connected = $false
    while (-not $connected) {
        $internetCheck = Test-Connection -ComputerName celieno.lan -Count 1 -Quiet
        if ($internetCheck) {
            $route = Get-NetRoute -DestinationPrefix 0.0.0.0/0
            While($route -eq $null) {
                delete route 0.0.0.0
            }

            Rename-Computer -NewName $newComputerName

            Add-Computer -DomainName "celieno.lan" -OUPath "OU=$choix_user,OU=Ordinateurs,DC=celieno,DC=lan"

            Restart-Computer
            $connected = $true
        } else {
            Write-Host "L'ordinateur n'est pas connecté à Internet, le script s'exécutera à nouveau dans 5 secondes."
            Start-Sleep -Seconds 5
        }
    }
} else {
    Write-Host "Annulation de l'opération."
    return
}

<#
$connected = $false
while (-not $connected) {
    $internetCheck = Test-Connection -ComputerName celieno.lan -Count 1 -Quiet
    if ($internetCheck) {
        $route = Get-NetRoute -DestinationPrefix 0.0.0.0/0
        While($route -eq $null) {
            delete route 0.0.0.0
        }

        Rename-Computer -NewName $newComputerName

        Add-Computer -DomainName "celieno.lan" -OUPath "OU=$choix_user,OU=Ordinateurs,DC=celieno,DC=lan"

        Restart-Computer
        $connected = $true
    } else {
        Write-Host "L'ordinateur n'est pas connecté à Internet, le script s'exécutera à nouveau dans 5 secondes."
        Start-Sleep -Seconds 5
    }
}
#>