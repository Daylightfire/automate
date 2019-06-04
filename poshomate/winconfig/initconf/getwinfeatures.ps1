$walpha = Get-WindowsFeature | where Installed

$walpha.Name > 'E:\temp\walpha.txt'