Write-Host "veuillez vous connecter à internet pour que le script fonctionne."

$namecomputer = Read-Host "Entrer le nouveau nom de l'ordinateur: "
$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables): "
$regex = "^[A-Z0-9-]{5,15}$"
$regex2 = "^[1-2]$"

while ($namecomputer -notmatch $regex) {
    Write-Host "Le nom de l'ordinateur ne respecte pas les caractères autorisés (majuscule, chiffre et tiret). Veuillez entrer un nom valide :"
    $namecomputer = Read-Host
}
if($ou_ad -like "1"){
    $choix_user = "Postes"
}elif($ou_ad -like "2"){
    $choix_user = "Portables"
}

Rename-Computer -NewName $namecomputer

$connected = $false
while (-not $connected) {
    $internetCheck = Test-Connection -ComputerName XXXXXXX.XXX -Count 1 -Quiet
    if ($internetCheck) {
        $route = Get-NetRoute -DestinationPrefix 0.0.0.0/0
        While($route -eq $null) {
            delete route 0.0.0.0
        }

        Add-Computer -DomainName "XXXXXXX.XXX" -OUPath "OU=$choix_user,OU=Ordinateurs,DC=XXXXXXX,DC=XXX"

        Restart-Computer
        $connected = $true
    } else {
        Write-Host "L'ordinateur n'est pas connecté à Internet, le script s'exécutera à nouveau dans 5 secondes."
        Start-Sleep -Seconds 5
    }
}
