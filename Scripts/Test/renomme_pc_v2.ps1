$choix_user = Read-Host "Veuillez choisir quel ordinateur c'est (1: Ordinateur de bureau ou 2: Ordinateur portable)"
$regex = "^[1-2]$"

while (!($choix_user -match $regex)) {
    Write-Host "Entrée non valide, veuillez choisir seulement 1 ou 2."
    return
}

$adapter = Get-NetAdapter -Name * | Select-Object InterfaceDescription, MacAddress

$ethernetAdapter = Get-NetAdapter -Name "Ethernet" -ErrorAction SilentlyContinue | Select-Object MacAddress
if ($ethernetAdapter) {
    $mac = $ethernetAdapter.MACAddress -replace "-", ""
} else {
    $networkAdapter = Get-NetAdapter -Name "Wi-Fi" -ErrorAction SilentlyContinue | Select-Object MacAddress
    $mac = $networkAdapter.MACAddress -replace "-", ""
    if (!$networkAdapter) {
        Write-Host "Aucun adaptateur réseau Ethernet ou Wi-Fi trouvé."
        return
    }
}

$newComputerName = if ($choix_user -eq "1") {
    "DESKTOP-" + $mac.Substring($mac.Length - 4)
} else {
    "LAPTOP-" + $mac.Substring($mac.Length - 4)
}

Write-Host "Résumé des actions à venir :"
foreach($adapters in $adapter){
    $mac = $adapters.Name + ", " + $adapters.InterfaceDescription + ", " + $adapters.MacAddress
    Write-Host "Carte réseau trouvé: $mac"
}
Write-Host "Nouveau nom de l'ordinateur : $newComputerName"
Write-Host "Redémarrage de l'ordinateur pour appliquer les modifications."
$confirm = Read-Host "Veuillez vérifier les informations ci-dessus et tapez 'Y' pour continuer, toute autre entrée pour annuler"

if ($confirm -eq "Y") {

    Rename-Computer -NewName $newComputerName
    shutdown /r /t 20 /c "Redémarrage de l'ordinateur dans 20 secondes"

    #Restart-Computer

} else {
    Write-Host "Annulation de l'opération."
    return
}
