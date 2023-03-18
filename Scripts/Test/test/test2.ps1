$computers = Get-ADComputer -Filter *

foreach ($computer in $computers) {
    $computerName = $computer.Name
    $computerGuid = $computer.ObjectGUID

    $bitLockerKey = Get-BitLockerVolume -MountPoint C: | 
                    Where-Object {$_.KeyProtector -like "*$computerGuid*"} | 
                    Select-Object -ExpandProperty KeyProtector

    if ($bitLockerKey) {
        $result = [PSCustomObject]@{
            ComputerName = $computerName
            Key = $bitLockerKey
        }
        $result
    }
}

$result | Out-File -FilePath ./test.log