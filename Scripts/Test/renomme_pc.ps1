$ou_ad = Read-Host "Veuillez choisir quel ordinateur c'est (1: Ordinateur de bureau ou 2: Ordinateur portable)"
$regex2 = "^[1-2]$"

while (!($ou_ad -match $regex2)) {
    Write-Host "Entrée non valide, veuillez choisir seulement 1 ou 2."
    return
}

$ethernetAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and $_.NetConnectionID -eq "Ethernet"}
if ($ethernetAdapter) {
    $mac = $ethernetAdapter.MACAddress -replace ":", ""
} else {
    $networkAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and $_.NetConnectionID -eq "Wi-Fi"}
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

Write-Host "Résumé des actions à venir :"
Write-Host "Voici tous les noms de carte réseau: $Adapter"
Write-Host "Nouveau nom de l'ordinateur : $newComputerName"
Write-Host "Redémarrage de l'ordinateur pour appliquer les modifications."
$confirm = Read-Host "Veuillez vérifier les informations ci-dessus et tapez 'Y' pour continuer, toute autre entrée pour annuler"

if ($confirm -eq "Y") {

    Rename-Computer -NewName $newComputerName
    shutdown /r /t 20 /c "Redémarrage de l'ordinateur dans 20 secondes"

} else {
    Write-Host "Annulation de l'opération."
    return
}
