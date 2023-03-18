$OUList = @("OU=Ordinateurs,DC=celieno,DC=lan",
            "CN=Computers,DC=celieno,DC=lan")

$Computers = Foreach($OU in $OUList){

    Get-ADComputer -Filter * -SearchBase $OU -Properties * | Select-Object Name, lastLogon, distinguishedName

}

$Computers = $Computers | Sort-Object lastLogon

$Computers = $Computers | Select-Object Name, @{Name='lastLogon';Expression={[DateTime]::FromFileTime($_.lastLogon)}}, distinguishedName | Export-Csv C:\Users\kidunat\Documents\final.csv -Encoding UTF8 -Delimiter ',' -Force