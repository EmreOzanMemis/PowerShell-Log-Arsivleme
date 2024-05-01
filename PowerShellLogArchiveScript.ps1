$LogFolder=“Clog_Dosyasi” 
$Arcfolder=“ClogsArsiv_Log_Dosyasi” 
$LastWrite=(get-date).AddDays(-7).ToString(MMddyyyy) 
If ($Logs = get-childitem $LogFolder  Where-Object {$_.LastWriteTime -le $LastWrite -and !($_.PSIsContainer)}  sort-object LastWriteTime) 
{ 
foreach ($L in $Logs) 
{ 
$FullName=$L.FullName 
$WMIFileName = $FullName.Replace(" ", "")
$WMIQuery = Get-WmiObject -Query “SELECT  FROM CIM_DataFile WHERE Name='$WMIFileName'“ 
If ($WMIQuery.Compress()) {Write-Host $FullName Arsivleme basarili.-ForegroundColor Green} 
else {Write-Host $FullName Arsivleme hatasi. -ForegroundColor Red}
