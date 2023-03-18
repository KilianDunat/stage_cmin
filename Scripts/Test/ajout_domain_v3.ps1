﻿Write-Host "Veuillez-vous connecter à internet pour que le script fonctionne."

$ComputerName = hostname
$test = 10

if ($ComputerName -like "LAPTOP-*") {
    $ou = "OU=Portables,OU=Ordinateurs,DC=celieno,DC=lan"
} elseif ($ComputeName -like "DESKTOP-*") {
    $ou = "OU=Postes,OU=Ordinateurs,DC=celieno,DC=lan"
} else {
    $ou = "OU=Ordinateurs,DC=celieno,DC=lan"
    return
}

Write-Host "Résumé des actions à venir :"
Write-Host "OU AD choisie : $ou"
Write-Host "Nom de l'ordinateur : $ComputerName"
Write-Host "Connexion au domaine : celieno.lan"
Write-Host "Redémarrage de l'ordinateur pour appliquer les modifications."
$confirm = Read-Host "Veuillez vérifier les informations ci-dessus et tapez 'Y' pour continuer, toute autre entrée pour annuler"

if ($confirm -eq "Y") {
    $connected = $false
    while (-not $connected) {
        $internetCheck = Test-Connection -ComputerName celieno.lan -Count 1 -Quiet
        if (($internetCheck) -and ($test -gt 0)){
            $removed = $false
            $tries = 0
            while (!$removed -or $tries -lt 10) {
                try {
                    Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -ErrorAction continue
                    $removed = $true
                    Write-Host $tries
                } catch {
                }
                $tries++
                Start-Sleep -Seconds 0.5
            }
            if (!$removed) {
                Write-Host "La passerelle par défault n'a pas pu être supprimée. Déconnexion de l'ordinateur d'Internet."
                netsh wlan disconnect
            } else {
                Write-Host "La passerelle par défault a été supprimée avec succès."
            }
            try{
            Add-Computer -DomainName "celieno.lan" -OUPath $ou
            }
            catch {
            $output += " error : $($_.Exception.Message)"
            $output | Write-Host
            return
            }
            shutdown /r /t 20 /c "Redémarrage de l'ordinateur dans 20 secondes"
            $connected = $true
        } else {
            $test -= 1
            Write-Host "L'ordinateur n'est pas connecté à Internet, le script s'exécutera à nouveau dans 5 secondes. Tentative numéro: $test"
            Start-Sleep -Seconds 5
        }
    }
} else {
    Write-Host "Annulation de l'opération."
    return
}