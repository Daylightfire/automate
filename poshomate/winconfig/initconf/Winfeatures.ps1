$winfea = Get-Content 'F:\scripts\docs\walpha.txt'

foreach ($b in $winfea) {
    if (Get-WindowsFeature -Name $b | Where-Object {$_. installstate -ne "installed"}){
    Write-Host "$b not installed"
    try{
    Install-WindowsFeature -Name $b -ErrorAction Stop
    Write-Host "$b installed"
    }
    Catch{
    write-host "$b failed to install"
    Write-Host "Exception Message: $($_.Exception.Message)" -forgroundColor Red
    }

    } else {write-host "$b installed" }
    
}