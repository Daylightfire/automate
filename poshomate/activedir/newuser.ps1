
<# This script should be run from a machine that has access to the Domain controller and has been given access to any required 
Non Domain machines.
All servers should be on PoSh 5+ especially the non domain servers as new-localuser etc requires PoSh 5
#>    
Import-Module ActiveDirectory


function main { 
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$first,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$last,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$comp
    )
    $userdeats = createuser $first $last $comp
    $userdeats
}


function createuser{
    param (
        
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$firstname,
        [Parameter(Position = 1, Mandatory = $true)]
        [string]$lastname,
        [Parameter(Position = 2, Mandatory = $true)]
        [string]$comp
    )
    $ndc = {"172.27.28.16", "172.27.28.17"}
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

#Select security group based on company name  
    switch ($comp) {
        "mmt" { $compgroup = "mmt users" }
        "csi"   {$compgroup = "CSI users"}
        Default {}
    }

# Output the user account and password
    [string]$Udeets = $newuser.Name | Out-File -FilePath 'e:\temp\user.txt' 
    [string]$Upeets  = $password | Out-file -FilePath 'e:\temp\user.txt' -Append

# Create user on DOMAIN, via the DOMAIN Controller
    invoke-command -ComputerName "" -Credential rootops\capt.america -ScriptBlock   {
        New-ADUser -Name $args[0] -GivenName $args[1] -Surname $args[2] -UserPrincipalName $args[3] -SamAccountName $args[4]  -AccountPassword $args[5] -Enabled $true
       Add-ADGroupMember -Identity "Domain Admins" -Members $args[4]
       Add-ADGroupMember -Identity $compgroup -Me
        } -ArgumentList $newuser.Name, $newuser.GivenName, $newuser.Surname,$newuser.UserPrincipalName,$newuser.SamAccountName,$newuser.password

# Create LOCAL user on NON DOMAIN joined Servers
    foreach($server in $ndc){
    Invoke-Command -ComputerName $args[2] -Credential $args[2]\graphite.rack -ScriptBlock {
        New-LocalUser -Name $args[0] -Password $args[1] -FullName $args[0] 
        Add-LocalGroupMember -Group "Users" -Member $args[0]
        Add-LocalGroupMember -Group "Administrators" -Member $args[0]

        } -ArgumentList $newuser.Name, $securep, $server
    }
}
function passowrd {
    $Getwords = Get-Content 'e:\scripts\\words.txt'
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

<#$firstName = Read-Host -Prompt "Input users First Name"
$lastName = Read-Host -Prompt "Input users Last Name"#>
$users = Import-Excel -Path 

foreach ($user in $users)   {
    $firstName = $user.firstname
    $lastName = $user.lastname
    $comp = $user.company
    main  -first $firstName -last $lastName -comp $comp

}
