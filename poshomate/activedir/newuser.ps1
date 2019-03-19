Import-Module ActiveDirectory

function main {
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$first,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$last
    )
    $userdeats = createuser $first $last
    $userdeats
}


function createuser{
    param (
        
        [Parameter(Position = 0, Mandatory = $true)]
        [string[]]$firstname,
        [Parameter(Position = 1, Mandatory = $true)]
        [string[]]$lastname
    )
    $words = Get-StringHash -String passowrd "md5"
    $pass = $words.Substring(0,16)
    $securep = ConvertTo-SecureString $pass -AsPlainText -Force 
    $newuser = @{

        'GivenName' = "$firstname"
        'Surname' = "$lastname"
        'UserPrincipalName' = ("$firstname.$lastname")
        'Name' = ("$firstname.$lastname")
        'SamAccountName' = ("$firstname.$lastname")
        'password' = $securep
    }
    return $newuser
}

function passowrd {
    $Getwords = Get-Content 'C:\project\automate\poshomate\activedir\words.txt'
    $string = (Get-Random -InputObject $Getwords) + (Get-Random -InputObject $Getwords) + (Get-Random -InputObject $Getwords)
    return $string
}

Function Get-StringHash([String] $String,$HashName = "MD5") { 
    $StringBuilder = New-Object System.Text.StringBuilder 
    [System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{ 
    [Void]$StringBuilder.Append($_.ToString("x2")) 
    } 
    $StringBuilder.ToString() 
}




main -first 'Steve' -last 'Rogers'