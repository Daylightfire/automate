# swap a key/value in AppSettings
Function swapAppSetting {
    param([string]$key,[string]$value )
    $obj = $doc.configuration.appSettings.add | where {$_.Key -eq $key }
    $obj.value = $value
  }
  
  
  $webConfig = "\\server\path\app.config"
  $doc = [Xml](Get-Content $webConfig)
  
  $doc.Save($webConfig)