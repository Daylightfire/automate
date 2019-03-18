Import-Module ActiveDirectory

function main {
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$first,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$last
    )
    $userdeats = createuser $first $last
    new-adUser $userdeats
}


function createuser{
    param (
        
        [Parameter(Position = 0, Mandatory = $true)]
        [string[]]$firstname,
        [Parameter(Position = 1, Mandatory = $true)]
        [string[]]$lastname
    )
    $newuser = @{

        'GivenName' = "$firstname"
        'Surname' = "$lastname"
        'UserPrincipalName' = ("$firstname.$lastname")
        'Name' = ("$firstname.$lastname")
        'SamAccountName' = ("$firstname.$lastname")
    }
    return $newuser
}

function passowrd {
    $Getwords = Get-Content 'D:\test\words.txt'
    $string = (Get-Random -InputObject $Getwords) + (Get-Random -InputObject $Getwords) + (Get-Random -InputObject $Getwords)
    $string
}


main -first 'Steve' -last 'Rogers'