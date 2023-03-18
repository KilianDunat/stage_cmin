$wifiSSID = Read-Host "Entrer le nom du wifi: "
$wifiPassword = Read-Host "Entrer le mot de passe wifi: "

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