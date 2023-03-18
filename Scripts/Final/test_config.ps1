Write-Host "Veuillez-vous connecter à internet pour que le script fonctionne."

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

            $taskName = "Rejoindre le domaine"
            $taskCommand = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command c:\Users\cmin\Documents\JoinDomain.ps1"
            $taskTrigger = New-ScheduledTaskTrigger -AtLogOn
            $taskAction = New-ScheduledTaskAction -Execute $taskCommand

            Write-Host "Ajout de la tâche planifiée $taskName"
            Register-ScheduledTask -TaskName $taskName -Trigger $taskTrigger -Action $taskAction -RunLevel Highest

            $NEWPROFILE = @'
            Write-Host "Veuillez-vous connecter à internet pour que le script fonctionne."
            Unregister-ScheduledTask -TaskName "Rejoindre le domaine" -Confirm:$false

            $ou_ad = Read-Host "Veuillez choisir quel ordinateur c'est (1: Ordinateur de bureau ou 2: Ordinateur portable)"
            $regex2 = "^[1-2]$"

            while (!($ou_ad -match $regex2)) {
                Write-Host "Entrée non valide, veuillez choisir seulement 1 ou 2."
                return
            }

            $ComputerName = hostname

            if ($ou_ad -eq "1") {
                $choix_user = "Postes"
            } else {
                $choix_user = "Portables"
            }

            Write-Host "Résumé des actions à venir :"
            Write-Host "OU AD choisie : OU=$choix_user,OU=Ordinateurs,DC=celieno,DC=lan"
            Write-Host "Nom de l'ordinateur : $ComputerName"
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

                        Add-Computer -DomainName "celieno.lan" -OUPath "OU=$choix_user,OU=Ordinateurs,DC=celieno,DC=lan"

                        Write-Host "Redémarrage de l'ordinateur dans 10 secondes."
                        Start-Sleep -Seconds 10 ; Restart-Computer
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
            }
'@

            $NEWPROFILE | Out-File c:\Users\cmin\Documents\JoinDomain.ps1

            Rename-Computer -NewName $newComputerName

            Write-Host "Redémarrage de l'ordinateur dans 10 secondes."
            Start-Sleep -Seconds 10
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
