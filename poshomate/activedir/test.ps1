$users = Import-Excel -Path C:\Test\users.xlsx
function print-user {
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$first,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$last,
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$comp
    )

    Write-Host "This users name is $first.$last and his company is $comp"
    
}

foreach ($user in $users)   {
    $firstname = $user.firstname
    $lastname = $user.lastname
    $comapny = $user.company

    print-user -first $firstname -last $lastname -comp $comapny

}



