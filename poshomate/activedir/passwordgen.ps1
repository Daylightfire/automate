#http://jongurgul.com/blog/get-stringhash-get-filehash/ 
Function Get-StringHash([String] $String,$HashName = "MD5") 
{ 
$StringBuilder = New-Object System.Text.StringBuilder 
[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{ 
[Void]$StringBuilder.Append($_.ToString("x2")) 
} 
$StringBuilder.ToString() 
}

function passowrd {
    $Getwords = Get-Content 'C:\projects\automate\poshomate\activedir\words.txt'
    $string = (Get-Random -InputObject $Getwords) + (Get-Random -InputObject $Getwords) + (Get-Random -InputObject $Getwords)
    Return $string
}

$pass = Get-StringHash -String passowrd "md5"

$word = $pass.Substring(0,16)
$count = $word.Length
$word
$count