Write-Host "Veuillez-vous connecter à internet pour que le script fonctionne."

$ComputerName = hostname
$test = 10
$testremoved = 0
$haserrors = $false

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
            While($testremoved -le 10){
                try{
                    Remove-NetRoute -DestinationPrefix 0.0.0.0/0
                    break
                }
                catch {
                    if(!$haserrors){
                        $haserrors = $true
                    }
                }
                $testremoved ++
                Start-Sleep -Seconds 0.5
            }
            if($testremoved -eq 10){
                netsh wlan disconnect
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
