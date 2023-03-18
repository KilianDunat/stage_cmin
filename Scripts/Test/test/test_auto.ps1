$wifiSSID = "myWifi"
$wifiPassword = "myPassword"
$domainName = "mydomain.com"
$username = "myusername"
$password = "mypassword"

while (($route = Get-NetRoute -DestinationPrefix 0.0.0.0/0) -ne $null) {
    Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -Confirm:$false
    Write-Host "La route par défaut a été supprimée."
    start-sleep -s 5
}
Write-Host "Aucune route par défaut n'a été trouvée."

Add-Type -AssemblyName System.Windows.Forms
$obj = New-Object System.Windows.Forms.Timer
$obj.Interval = 1000
$obj.Enabled = $true
$obj.Start()

while (($wifi = Get-NetConnectionProfile -Name $wifiSSID) -eq $null) {
    [System.Windows.Forms.MessageBox]::Show("Connecting to wifi '$wifiSSID'...")
    Add-Type -AssemblyName System.Windows.Forms
    $obj.Stop()
    $obj.Enabled = $false
    $obj = $null
    Add-Type -AssemblyName System.Management.Automation
    [System.Management.Automation.PSCredential]$cred = New-Object System.Management.Automation.PSCredential($username,(ConvertTo-SecureString $password -AsPlainText -Force))
    $profile = [Wlan.WlanClient]::Connect($wifiSSID,$cred)
    start-sleep -s 5
}
Write-Host "Connected to wifi '$wifiSSID'."

Add-Computer -DomainName $domainName -Credential $cred
Write-Host "The computer has joined the domain '$domainName'."
