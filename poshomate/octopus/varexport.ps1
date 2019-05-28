Install-Module -Name Octoposh -Force
Install-Module ImportExcel


Import-Module Octoposh

$octourl = ""
$octokey = ""
Set-OctopusConnectionInfo -Server $octourl -ApiKey $octokey
$projnames = Get-OctopusProject | Select-Object "Name"

foreach($proj in $projnames){
    Write-Host $proj.Name
    $name = $proj.Name
    $xlsx = "$name.xlsx"
    $path = "E:\tmp\$xlsx"
    $getvar = Get-OctopusVariableSet -ProjectName $name
    $getvar.Variables | Select-Object "Name", "Value" | Export-Excel -Path $path
}