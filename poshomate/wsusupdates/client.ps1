$updates = ""

if(Get-WindowsUpdate) {
    $updates = "Installing updates"
    Get-WindowsUpdate -install -acceptall -autoreboot
        }
else{
    $updates = "No Updates found"
    }
Send-MailMessage -SmtpServer '172.27.33.53' -From 'noreply.axelos.com' -To 'john.root@axelos.com' -Subject 'Patching' -Body $updates