$sitename = ''
$hostheader = ''
$iispath = 'F:\websites\'
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
$sitepath = "$iispath\$sitename"
# Create website
Write-Host "Creating application pool and website"
$apppool = New-WebAppPool -Name $sitename -Force
if (!(Test-Path $iispath)){
    write-host "path does not exist Creating now"
    New-Item -Path $iispath -ItemType Directory
}
if (!(Test-Path $sitepath)){
    write-host "path does not exist, Creating now"
    New-Item -Path $sitepath -ItemType Directory
}
New-Website -Name $sitename -Port 80 -HostHeader $hostheader -PhysicalPath $sitepath -ApplicationPool $apppool

