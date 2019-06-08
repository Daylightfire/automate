<# param (
        [Parameter(Position = 0, Mandatory = $true,  ValueFromPipeline = $true)]
        [string]$firstName,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$lastName
    )#>
Import-Module ActiveDirectory


function main {
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$first,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$last
    )
    $userdeats = createuser $first $last
    $userdeats
}


function createuser{
    param (
        
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$firstname,
        [Parameter(Position = 1, Mandatory = $true)]
        [string]$lastname
    )
    $words = Get-StringHash -String passowrd "md5"
    $pass = $words.Substring(0,16)
    $password = special($pass)
    $password = special($password)
    $password = special($password)

    $securep = ConvertTo-SecureString $password -AsPlainText -Force 
    $newuser = @{

        GivenName = $firstname
        Surname = "$lastname"
        UserPrincipalName = ("$firstname.$lastname")
        Name = ("$firstname.$lastname")
        SamAccountName = ("$firstname.$lastname")
        password = $securep
    }
    [string]$Udeets = $newuser.Name | Out-File -FilePath 'C:\temp\user.txt' 
    [string]$Upeets  = $password | Out-file -FilePath 'C:\temp\user.txt' -Append
    New-ADUser -Name $newuser.Name -GivenName $newuser.GivenName -Surname $newuser.Surname -UserPrincipalName $newuser.UserPrincipalName -SamAccountName $newuser.SamAccountName -AccountPassword $newuser.password
    Add-ADGroupMember -Identity "Domain Admins" -Members $newuser.SamAccountName
    Add-ADGroupMember -Identity "MMT Users" -Members $newuser.SamAccountName
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

function special([String] $pw)    {
    $splist = @("!",'"', '\', "$", "%", "^", "&", "*", "/")
    $spaff = Get-Random -InputObject $splist -Count 1
    $Select = Get-Random -Maximum 15
    $a = $pw[$Select]
    $pwspec = $pw.Replace($a, $spaff)
    
    Return $pwspec
}

$firstName = Read-Host -Prompt "Input users First Name"
$lastName = Read-Host -Prompt "Input users Last Name"

main  -first $firstName -last $lastName