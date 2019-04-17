$firstname = read-host

$newuser = @{
    GivenName = $firstname
    Surnam = "Bon"
    }


Write-host $newuser.GivenName

