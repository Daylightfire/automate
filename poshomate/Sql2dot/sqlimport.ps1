
$serverin = 'WPSLTPC0HFWYJ\SQLEXPRESS'
$database = 'testytest'


$data = Import-Excel -Path 'C:\test\CandidateData.xlsx'
foreach ($d in $data) {
    $email =  $d.'Email Address'
    $consent = $d.'Consent?'
    $fname = $d.'First Name'
    $lname = $d.'Last Name'
    $source = $d.OPTINSOURCE
    $sql = @"
    INSERT INTO [dbo].[dottest]
                ([email]
                ,[consent]
                ,[firstname]
                ,[lastname]
                ,[optsource]
                )

            VALUES
                ('$email'
                ,'$consent'
                ,'$fname'
                ,'$lname'
                ,'$source')
Go

"@
    Write-host $email

Invoke-Sqlcmd -Query $sql -ServerInstance $serverin -Database $database

}

