$updates = Get-WUHistory 
$updates | Where-Object {(Get-Date($_.Date)).ToString("dd/MM/yyyy") -eq (get-date).AddDays(-1).ToString("dd/MM/yyyy")}


$a = 14
$b = 13

If ($a -gt $b)  {
    write-host ""
}
$date = (get-date).Adddays(-1).AddDays(-1).ToString("dd/MM/yyyy")

$date



SELECT * FROM [K10.dev].[dbo].[OM_Activity] where ActivityCreated > '2018-05-00 00:09:34.2380720' AND ActivityURL LIKE '%/policies/privacy-policy%'