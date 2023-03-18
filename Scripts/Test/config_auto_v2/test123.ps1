$ou_ad = Read-Host "Veuillez choisir où votre ordinateur sera dans l'active directory (1:Postes ou 2:Portables): "
$regex = "^[1-2]$"

if (!($ou_ad -match $regex)) {
    Write-Host "Entrée non valide, veuillez réessayer."
    return
}

$networkAdapter = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $True} | Select-Object -First 1
$mac = $networkAdapter.MACAddress -replace ":", ""
$newComputerName = if ($ou_ad -eq "1") { "DESKTOP-" } else { "LAPTOP-" } + $mac.Substring($mac.Length - 4)
