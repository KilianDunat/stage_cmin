$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables): "
$regex = "^[1-2]$"

if (!($ou_ad -match $regex)) {
    Write-Host "Entrée non valide, veuillez réessayer."
    return
}

$networkAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True -and ($_.NetConnectionID -eq "Ethernet" -or $_.NetConnectionID -eq "Wi-Fi")} | Select-Object -First 1
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
 "LAPTOP-" + $mac.Substring($mac.Length - 4) } #+ $mac.Substring($mac.Length - 4)

$choix_user | Write-Host
$newComputerName | Write-Host