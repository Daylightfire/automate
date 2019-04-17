function special    {
    $splist = @("!",'"', '\', "$", "%", "^", "&", "*", "/")
    $spaff = Get-Random -InputObject $splist -Count 1
    Return $spaff
}

special
