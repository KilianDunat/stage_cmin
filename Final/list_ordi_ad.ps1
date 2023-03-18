Param([Parameter()]
    $chemin)

If($null -eq $chemin) 
{
  $chemin = ".\liste_Ordi_AD.csv"
}
$OUList = @("OU=Ordinateurs,DC=celieno,DC=lan",
            "CN=Computers,DC=celieno,DC=lan")
$Computers = Foreach($OU in $OUList){
    Get-ADComputer -Filter * -SearchBase $OU -Properties lastLogon | Select-Object Name, lastLogon, distinguishedName
}
$Computers = $Computers | Sort-Object lastLogon
$Computers = $Computers | Select-Object Name, @{Name='lastLogon';Expression={[DateTime]::FromFileTime($_.lastLogon)}}, distinguishedName | Export-Csv $chemin -notype -Encoding UTF8 -Delimiter ';' -Force
