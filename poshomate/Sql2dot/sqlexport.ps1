#Install-Module ImportExcel


$serverin = 'WPSLTPC0HFWYJ\SQLEXPRESS'
$filepath = "C:\projects\sqlstuff\$(get-date -f yyyy-MM-dd)_dottest.xlsx"
$database = 'testytest'

$qu = @"

    SELECT * FROM [testytest].[dbo].[dottest]

"@


$result = Invoke-Sqlcmd -Query $qu -ServerInstance $serverin -Database $database


$result 
#|  export-excel -Path $filepath -ExcludeProperty RowError, RowState, Table, ItemArray, HasErrors 

$serverin = 'TDWH1'
$filepath = "C:\projects\sqlstuff\$(get-date -f yyyy-MM-dd)_dottest.xlsx"
$database = 'AxelosDWH'

$qu = @"

    SELECT * FROM [AxelosDWH].[AxelosReporting].[Contacts]

"@


$result = Invoke-Sqlcmd -Query $qu -ServerInstance $serverin -Database $database


$result 

$dblist = @( 'DDWH1', 'DRPWDB1', 'DREP1') 

foreach ($db in $dblist) {

$showdbs = Get-SqlDatabase -ServerInstance $db | Select-Object -Property 'Parent','Name', 'Owner'
$showdbs | Export-Excel -Path 'E:\Tmp\dev.xlsx' -Append
}