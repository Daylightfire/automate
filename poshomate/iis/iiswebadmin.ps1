$sitename = ''
$hostheader = ''
$iispath = 'F:\websites\'
$sitepath = "$iispath\$sitename"
$hostname = hostname

# Remove Defaults
if (get-website -Name 'Default Web Site'){
    Write-Host "Default website exists"
    Remove-Website -Name 'Default Web Site'
    Remove-WebAppPool -Name 'DefaultAppPool'
    Remove-WebAppPool -Name '.NET v4.5'
    Remove-WebAppPool -Name '.NET v4.5 Classic'
} else {Write-Host " Default WebSite does not exist"}

#Getsite name 
switch ($hostname) {
    DCPDAPP { ($sitename = "cpd-app") , ($hostheader = "wcf.dev.axelos.com")}
    DCPDWEB { ($sitename = "cpd-web") , ($hostheader = "cpd.dev.axelos.com")}
    DK10WEB { ($sitename = "axe-cms") , ($hostheader = "dev.axelos.com")}
    Default {Write-Host "Balls"}
}

# Create website
Write-Host "Creating application pool and website"
$apppool = New-WebAppPool -Name $sitename
New-Website -Name $sitename -Port 80 -HostHeader $hostheader -PhysicalPath $sitepath -ApplicationPool $apppool