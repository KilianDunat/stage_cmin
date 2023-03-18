$OUList = @("OU=Ordinateurs,DC=celieno,DC=lan",
            "CN=Computers,DC=celieno,DC=lan")

$Computers = Foreach($OU in $OUList){

    Get-ADComputer -Filter * -SearchBase $OU -Properties * | Select-Object Name, @{Name='lastLogon1';Expression={[DateTime]::FromFileTime($_.lastLogon)}}, distinguishedName, lastLogon | Sort-Object lastLogon

}

$Computers | Export-CSV -Path "C:\Users\kidunat\Documents\Computers.csv" -NoTypeInformation

$OriginalFile = 'C:\Users\kidunat\Documents\Computers.csv';
$ExportFile = 'C:\Users\kidunat\Documents\Computers2.csv';

Import-Csv $OriginalFile -Encoding UTF8 -Delimiter ',' | Sort-Object lastLogon | Export-Csv $ExportFile -Encoding UTF8 -Delimiter ',' -Force
Remove-Item C:\Users\kidunat\Documents\Computers.csv

$OriginalFile = 'C:\Users\kidunat\Documents\Computers2.csv';
$ExportFile = 'C:\Users\kidunat\Documents\final.csv';

Import-Csv $OriginalFile -Encoding UTF8 -Delimiter ',' | Select-Object Name, @{Name='lastLogon';Expression={[DateTime]::FromFileTime($_.lastLogon)}}, distinguishedName | Export-Csv $ExportFile -Encoding UTF8 -Delimiter ',' -Force
Remove-Item C:\Users\kidunat\Documents\Computers2.csv
