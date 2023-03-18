$CSVFile = "C:\Script\Utilisateurs.csv" 

$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8 

 

Foreach($Utilisateur in $CSVData){ 

 

    $UtilisateurPrenom = $Utilisateur.Prenom 

    $UtilisateurNom = $Utilisateur.Nom 

    $UtilisateurLogin = $UtilisateurPrenom.ToLower() + "." + $UtilisateurNom.ToLower() 

    $UtilisateurEmail = "$UtilisateurLogin@corp.kilian.com" 

    $UtilisateurMotDePasse = "P@ssw0rd" 

    $UtilisateurFonction = $Utilisateur.Fonction 

    $UtilisateurService = $Utilisateur.Service 

 

    # Vérifier la présence de l'utilisateur dans l'AD 

    if (Get-ADUser -Filter {SamAccountName -eq $UtilisateurLogin}) 

    { 

        Write-Warning "L'identifiant $UtilisateurLogin existe déjà dans l'AD" 

    } 

    else 

    { 

        New-ADUser -Name "$UtilisateurPrenom $UtilisateurNom" ` 

                    -DisplayName "$UtilisateurPrenom $UtilisateurNom" ` 

                    -GivenName $UtilisateurPrenom ` 

                    -Surname $UtilisateurNom ` 

                    -SamAccountName $UtilisateurLogin ` 

                    -UserPrincipalName "$UtilisateurLogin@corp.kilian.com" ` 

                    -EmailAddress $UtilisateurEmail ` 

                    -Title $UtilisateurFonction ` 

                    -Path "OU=Utilisateurs,OU=$UtilisateurService,OU=Service,DC=corp,DC=kilian,DC=com" ` 

                    -AccountPassword(ConvertTo-SecureString $UtilisateurMotDePasse -AsPlainText -Force) ` 

                    -ChangePasswordAtLogon $false ` 

                    -Enabled $true 

 

        Write-Output "Création de l'utilisateur : $UtilisateurLogin ($UtilisateurPrenom $UtilisateurNom)" 

    } 

}