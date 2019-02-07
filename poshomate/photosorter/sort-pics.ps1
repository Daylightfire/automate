function Get-FileMetaData 
{ 
    
    param([Parameter(Mandatory=$True)][string]$File = $(throw "Parameter -File is required.")) 
 
    if(!(Test-Path -Path $File)) 
    { 
        throw "File does not exist: $File" 
        Exit 1 
    } 
 
    $tmp = Get-ChildItem $File 
    $pathname = $tmp.DirectoryName 
    $filename = $tmp.Name 
 
    $shellobj = New-Object -ComObject Shell.Application 
    $folderobj = $shellobj.namespace($pathname) 
    $fileobj = $folderobj.parsename($filename) 
    $results = New-Object PSOBJECT 
    for($a=0; $a -le 294; $a++) 
    { 
        if($folderobj.getDetailsOf($folderobj, $a) -and $folderobj.getDetailsOf($fileobj, $a))  
        { 
            $hash += @{$($folderobj.getDetailsOf($folderobj, $a)) = $($folderobj.getDetailsOf($fileobj, $a))} 
            $results | Add-Member $hash -Force 
        } 
    } 
    $results 
} 

function sort-image {
    param([Parameter(Mandatory=$True)][string]$imagespath = $(throw "Parameter -File is required."))
$n = 1    
$folder = Get-ChildItem $imagespath
foreach ($i in $folder) {
    $image = Get-FileMetaData -File "$imagespath\$i" | Select-Object -Property 'Date Taken'
    $datetime = $image.'Date taken' -Split " " -replace "/","-"
    $date = $datetime[0]
    Rename-Item -Path "$imagespath\$i" -NewName "$date.jpg"
    if (Test-Path $imagespath\$date){
        if (Test-Path "$imagespath\$date\$date.jpg" ){
            Rename-Item -Path "$imagespath\$date\$date.jpg"-NewName "$imagespath\$date\$date-$n.jpg"
            $n = $n + 1
            Rename-Item "$imagespath\$date.jpg" -NewName "$imagespath\$date-$n.jpg"
            Move-Item -Path "$imagespath\$date-$n.jpg"-Destination "$imagespath\$date"
            $n = $n + 1
            }
            else {
                Rename-Item "$imagespath\$date.jpg" -NewName "$imagespath\$date-$n.jpg"
                Move-Item -Path "$imagespath\$date-$n.jpg"-Destination "$imagespath\$date"
                $n = $n + 1
                }
        }
        else {
            New-Item -Name $date -ItemType 'directory' -Path "$imagespath\"
            Move-Item -Path "$imagespath\$date.jpg" -Destination "$imagespath\$date"
            $n = 1
            }
    
    }
}
sort-image -imagespath [ENTER PATH HERE]