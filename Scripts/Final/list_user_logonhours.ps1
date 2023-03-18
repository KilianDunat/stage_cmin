$logonTest3 = "255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255"


 $users = Get-aduser -Filter * 
 ForEach($user in $users)  
{  

    [string]$hours = get-aduser $user -Properties LogonHours | select LogonHours
    
    
    if ($hours -ne $logonTest3 -and $hours -ne $null){
    get-aduser $user | Select-Object Name, DistinguishedName | Export-Csv .\list_user_accestimeactivate.csv -notype -Encoding UTF8 -Delimiter ';' -Force
    }
}
