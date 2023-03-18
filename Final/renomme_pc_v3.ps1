function choix {
    $1 = "Veuillez choisir 1 pour choisir le nom réalisé avec les 4 derniers chiffres de l'adresse mac de l'interface Ethernet: $name-" + $macethernet.Substring($macethernet.Length - 4)
    $2 = "Veuillez choisir 2 pour choisir le nom réalisé avec les 4 derniers chiffres de l'adresse mac de l'interface Wi-Fi: $name-" + $macwifi.Substring($macwifi.Length - 4)
    $3 = "Veuillez choisir 3 pour choisir l'interface réseau que vous voulez."
    $4 = "Veuillez choisir 4 pour pouvoir personnaliser le nom de l'ordinateur."
    Write-Output $1
    Write-Output $2
    Write-Output $3
    Write-Output $4
}

$choix_user_com = Read-Host "Veuillez choisir quel ordinateur c'est (1: Ordinateur de bureau ou 2: Ordinateur portable)"
$regex = "^[1-2]$"
$regex2 = "^[1-4]$"
$regex3 = "^[a-zA-Z0-9-]+$"

if($choix_user_com -eq "1"){
    $name = "DESKTOP"
}elseif($choix_user_com -eq "2"){
    $name = "LAPTOP"
}

while (!($choix_user_com -match $regex)) {
    Write-Host "Entrée non valide, veuillez choisir seulement 1 ou 2."
    Write-Host "Arret de l'opération."
    return
}

$adapter = Get-NetAdapter -Name * | Select-Object Name, InterfaceDescription, MacAddress

foreach($adapters in $adapter){
    $networkcard = $adapters.Name + ", " + $adapters.InterfaceDescription + ", " + $adapters.MacAddress
    Write-Host "Carte réseau trouvé: $networkcard"
}

$ethernetAdapter = Get-NetAdapter -Name "Ethernet" -ErrorAction SilentlyContinue | Select-Object MacAddress
$networkAdapter = Get-NetAdapter -Name "Wi-Fi" -ErrorAction SilentlyContinue | Select-Object MacAddress
if (($ethernetAdapter) -and ($networkAdapter)) {
    $macethernet = $ethernetAdapter.MACAddress -replace "-", ""
    $macwifi = $networkAdapter.MACAddress -replace "-", ""
} else {
    Write-Host "Aucun adaptateur réseau Ethernet ou Wi-Fi trouvé."
}

if ($choix_user_com -eq "1") {
    choix
} else {
    choix
}


$confirm2 = 0
while($confirm2 -ne "Y"){
    $choix_user_net = Read-Host "Veuillez choisir quel nom voudriez-vous pour l'ordinateur (entre 1 et 4)"
    if($choix_user_com -eq "1"){
        if($choix_user_net -eq "1"){
            $newComputerName = "$name-" + $macethernet.Substring($macethernet.Length - 4)
        }elseif($choix_user_net -eq "2"){
            $newComputerName = "$name-" + $macwifi.Substring($macwifi.Length - 4)
        }elseif($choix_user_net -eq "3"){
            $names = Read-Host "Veuillez entrer le nom de l'interface réseau que vous voulez"
            $otherAdapter = Get-NetAdapter -Name "$names" | Select-Object MacAddress
            $mac = $otherAdapter.MACAddress -replace "-", ""
            $newComputerName = "$name-" + $mac.Substring($mac.Length - 4)
        }
    }elseif ($choix_user_com -eq "2"){
        if($choix_user_net -eq "1"){
            $newComputerName = "$name-" + $macethernet.Substring($macethernet.Length - 4)
        }elseif($choix_user_net -eq "2"){
            $newComputerName = "$name-" + $macwifi.Substring($macwifi.Length - 4)
        }elseif($choix_user_net -eq "3"){
            $names = Read-Host "Veuillez entrer le nom de l'interface réseau que vous voulez"
            $otherAdapter = Get-NetAdapter -Name "$names" | Select-Object MacAddress
            $mac = $otherAdapter.MACAddress -replace "-", ""
            $newComputerName = "$name-" + $mac.Substring($mac.Length - 4)
        }
    }
    if($choix_user_net -eq "4"){
        $newComputerName = Read-Host "Veuillez entrer le nom de l'ordinateur personnaliser"
    }
    While (!($newComputerName -match $regex3)) {
        Write-Host "Entrée non valide, le nom de l'ordinateur doit contenir soit majuscule, minuscule, chiffre et tiret."
        Write-Host "Arret de l'opération."
        return
    }
    While (!($choix_user_net -match $regex2)) {
        Write-Host "Entrée non valide, veuillez choisir seulement 1, 2, 3 ou 4."
        Write-Host "Arret de l'opération."
        return
    }
    Write-Host "Le nom choisi est $newComputerName"
    $confirm2 = Read-Host "Veuillez confirmer le nom choisi ci-dessus et tapez 'Y' pour continuer, tapez 'R' pour recommencer et toute autre entrée pour annuler"
    if(($confirm2 -ne "Y") -and ($confirm2 -ne "R")){
        Write-Host "Annulation de l'opération."
        return
    }
}

Write-Host "Résumé des actions à venir :"
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
