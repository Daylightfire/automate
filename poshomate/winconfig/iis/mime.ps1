Function Set-MimeTypeIfNotPresent
{
  <#
    .SYNOPSIS
    Associates file extension with MIME type in IIS
  #>


    param(
        [Parameter(Mandatory=$true)]
        [string]$fileExtension,
        [Parameter(Mandatory=$true)]
        [string]$mimeType
    )

    $config = Get-WebConfiguration -Filter system.webServer/staticContent/mimeMap | Where-Object { $_.fileExtension -eq $fileExtension }

    if($config -eq $null)
    {
        Write-Output -InputObject "'$fileExtension' file extension configuration not found. Adding with MIME type '$mimeType'"
        Add-WebConfiguration -Filter system.webServer/staticContent -AtIndex 0 -Value @{fileExtension=$fileExtension; mimeType=$mimeType}
    } 
    else 
    {
        Write-Output -InputObject "Configuration for '$fileExtension' found. No changes will be performed"
    }
}

function Set-handlerifnotpresent {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Verb,
        [Parameter(Mandatory=$true)]
        [string]$Modules,
        [Parameter(Mandatory=$true)]
        [string]$PSPath
    )
    $config = Get-WebConfiguration -Filter system.webServer/handlers/* | Where-Object { $_.Name -eq $Name }
    if ( $config -eq $null){
        Write-Output -InputObject "'$Name' file extension configuration not found. Adding with Handler path type '$Path'"    
        New-WebHandler -Name $Name -Path $Path -Verb $Verb -Modules $Modules -PSPath $PSPath
       } else {Write-Output -InputObject "Configuration for '$Name' found. No changes will be performed"}
}
$mimes = Import-Csv -Path F:\scripts\docs\mime.csv
$hands = Import-Csv -Path F:\scripts\docs\hand.csv

foreach ($mime in $mimes){
    $fileExt = $mime.fileExtension
    $mimeTy = $mime.mimeType
    Set-MimeTypeIfNotPresent -fileExtension $fileExt -mimeType $mimeTy
}

foreach ($hand in $hands){
    $n = $hand.Name
    $p = $hand.Path
    $v = $hand.Verb
    $m = $hand.Modules
    $pp = $hand.PSPath

    Set-handlerifnotpresent -Name $n -Path $p -Verb $v -Modules $m -PSPath $pp
}