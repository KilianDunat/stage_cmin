$List = Get-ADComputer -Filter * -SearchBase "OU=Ordinateurs,DC=celieno,DC=lan" -Properties *| Select-Object Name, @{Name='lastLogon';Expression={[DateTime]::FromFileTime($_.lastLogon)}} | Sort-Object lastLogon | Out-File -Filepath "C:\Users\kidunat\Documents\Computers.csv"
#Get-Content C:\Users\kidunat\Documents\Computers.csv
$List += Get-ADComputer -Filter * -SearchBase "CN=Computers,DC=celieno,DC=lan" -Properties *| Select-Object Name, @{Name='lastLogon';Expression={[DateTime]::FromFileTime($_.lastLogon)}} | Sort-Object lastLogon | Out-File -FilePath "C:\Users\kidunat\Documents\Computers1.csv"
Get-Content C:\Users\kidunat\Documents\Computers1.csv | Select-Object -Skip 2 | Set-Content  C:\Users\kidunat\Documents\Computers2.csv 
Remove-Item C:\Users\kidunat\Documents\Computers1.csv
Get-Content C:\Users\kidunat\Documents\Computers.csv | Select-Object -Skip 1 | Set-Content  C:\Users\kidunat\Documents\Computers1.csv 
Remove-Item C:\Users\kidunat\Documents\Computers.csv


$OriginalFile = 'C:\Users\kidunat\Documents\Tot_Computers.csv';
$ExportFile = 'C:\Users\kidunat\Documents\final.csv';
<#
$CSV= @();

Get-ChildItem -Path $CSVFolder -Filter *.csv | ForEach-Object { 
    $CSV += @(Import-Csv -Path $_)
}

$CSV | Export-Csv -Path $OutputFile -NoTypeInformation -Force;
#>

cmd /c copy  ((gci "C:\Users\kidunat\Documents\*.csv" -Name) -join '+') "C:\Users\kidunat\Documents\Tot_Computers.csv" 
Import-Csv $OriginalFile -Encoding UTF8 -Delimiter ';'| Sort-Object lastLogon | Export-Csv $ExportFile -Encoding UTF8 -Delimiter ';' -Force