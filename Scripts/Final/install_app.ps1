# Vérifiez si Chocolatey est déjà installé
if (!(Get-Command choco.exe -ErrorAction Ignore)) {
    # Téléchargez et installez Chocolatey
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Installez plusieurs logiciels en une seule commande à l'aide de Chocolatey
choco install keepass -y openvpn -y adobereader -y