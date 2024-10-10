$LogFolder = "Clog_Dosyasi"
$Arcfolder = "ClogsArsiv_Log_Dosyasi"
$LastWrite = (get-date).AddDays(-7).ToString("MMddyyyy")

# Ensure the archive folder exists
if (-not (Test-Path -Path $Arcfolder)) {
    New-Item -ItemType Directory -Path $Arcfolder
}

$Logs = Get-ChildItem $LogFolder | Where-Object {
    $_.LastWriteTime -le [datetime]::ParseExact($LastWrite, "MMddyyyy", $null) -and -not $_.PSIsContainer
} | Sort-Object LastWriteTime

if ($Logs) {
    foreach ($L in $Logs) {
        $FullName = $L.FullName
        $WMIFileName = $FullName.Replace(" ", "")
        $WMIQuery = Get-WmiObject -Query "SELECT * FROM CIM_DataFile WHERE Name='$WMIFileName'"
        
        if ($WMIQuery.Compress()) {
            $DestinationPath = Join-Path -Path $Arcfolder -ChildPath $L.Name
            Move-Item -Path $FullName -Destination $DestinationPath
            Write-Host "$FullName Arsivleme ve tasima basarili." -ForegroundColor Green
        } else {
            Write-Host "$FullName Arsivleme hatasi." -ForegroundColor Red
        }
    }
}
