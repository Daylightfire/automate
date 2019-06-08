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

# Generate unique password
    $words = Get-StringHash -String passowrd "md5"
    $pass = $words.Substring(0,16)
    $password = special($pass)
    $password = special($password)
    $password = special($password)

    $securep = ConvertTo-SecureString $password -AsPlainText -Force 

 # Create user details   
    $newuser = @{

        GivenName = $firstname
        Surname = $lastname
        UserPrincipalName = ("$firstname.$lastname")
        Name = ("$firstname.$lastname")
        SamAccountName = ("$firstname.$lastname")
        password = $securep
    }
# Output the user account and password
    [string]$Udeets = $newuser.Name | Out-File -FilePath 'C:\temp\user.txt' 
    [string]$Upeets  = $password | Out-file -FilePath 'C:\temp\user.txt' -Append

# Create user on DOMAIN, via the DOMAIN Controller
    invoke-command -ComputerName "win2012r2dc" -Credential rootops\capt.america -ScriptBlock   {
        New-ADUser -Name $args[0] -GivenName $args[1] -Surname $args[2] -UserPrincipalName $args[3] -SamAccountName $args[4]  -AccountPassword $args[5] -Enabled $true
       Add-ADGroupMember -Identity "Domain Admins" -Members $args[4]
       Add-ADGroupMember -Identity "MMT Users" -Members $args[4]
        } -ArgumentList $newuser.Name, $newuser.GivenName, $newuser.Surname,$newuser.UserPrincipalName,$newuser.SamAccountName,$newuser.password

# Create LOCAL user on NON DOMAIN joined Servers
    Invoke-Command -ComputerName "win2012r2nondc" -Credential win2012r2nondc\scarlet.witch -ScriptBlock {
        New-LocalUser -Name $args[0] -Password $args[1] -FullName $args[0] 
        Add-LocalGroupMember -Group "Users" -Member $args[0]
        Add-LocalGroupMember -Group "Administrators" -Member $args[0]

        } -ArgumentList $newuser.Name, $securep
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