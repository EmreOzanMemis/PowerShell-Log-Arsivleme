# Powershell Log Arsivleme Scripti
```
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
```

Bu PowerShell scripti, belirli bir klasördeki eski log dosyalarını arşivlemek için kullanılır. Script, belirli bir tarihten eski olan dosyaları tespit eder, bu dosyaları sıkıştırır ve başarılı bir şekilde sıkıştırıldığını doğrular. İşte scriptin detaylı bir açıklaması ve kullanım amacı:

Değişken Tanımlamaları:
```
$LogFolder=“Clog_Dosyasi” 
$Arcfolder=ClogsArsiv_Log_Dosyasi” 
$LastWrite=(get-date).AddDays(-7).ToString("MMddyyyy")
```
$LogFolder: Log dosyalarının bulunduğu klasör yolu.
$Arcfolder: Arşivlenecek log dosyalarının taşınacağı klasör yolu.
$LastWrite: Scriptin çalıştığı tarihten 7 gün önceki tarihi temsil eder. Bu tarih, hangi dosyaların arşivleneceğini belirlemek için bir kriter olarak kullanılır.

Dosya Filtreleme ve Sıralama:
```
If ($Logs = get-childitem $LogFolder | Where-Object {$_.LastWriteTime -le $LastWrite -and !($_.PSIsContainer)} | sort-object LastWriteTime)
```
Get-ChildItem $LogFolder: Belirtilen klasördeki tüm dosya ve klasörleri listeler.

Where-Object {$_.LastWriteTime -le $LastWrite -and !($_.PSIsContainer)}: Belirtilen tarihten eski olan ve klasör olmayan (yani dosya olan) öğeleri filtreler.

Sort-Object LastWriteTime: Dosyaları son değiştirilme zamanlarına göre sıralar.

Dosya İşleme Döngüsü:
```
foreach ($L in $Logs) 
{ 
$FullName=$L.FullName 
$WMIFileName = $FullName.Replace(" ", "") 
$WMIQuery = Get-WmiObject -Query “SELECT * FROM CIM_DataFile WHERE Name='$WMIFileName'“ 
```
$FullName=$L.FullName: İşlenecek dosyanın tam yolunu alır.
$WMIFileName= $FullName.Replace(, ): Dosya adından boşlukları kaldırmak için kullanılır
$WMIQuery = Get-WmiObject -Query: Belirtilen dosya adıyla WMI (Windows Management Instrumentation) üzerinden sorgulama yapar. Bu sorgu, dosyanın WMI üzerinden yönetilmesini sağlar.

Dosya Sıkıştırma ve Sonuç Kontrolü:
```
If ($WMIQuery.Compress()) {Write-Host $FullName Arsivleme basarili.-ForegroundColor Green} 
else {Write-Host $FullName Arsivleme hatasi. -ForegroundColor Red}
```
$WMIQuery.Compress(): WMI aracılığıyla dosyayı sıkıştırma işlemi gerçekleştirir.
Write-Host: İşlem sonucunu konsolda gösterir. Başarılıysa yeşil, hata varsa kırmızı renkte mesaj verir.

Neden ve Ne Amaçla Kullanılır?

Bu script, sistem yöneticileri ve IT profesyonelleri tarafından kullanılır ve aşağıdaki amaçlar için önemlidir:

  Disk Alanı Tasarrufu: Eski log dosyalarını sıkıştırarak disk alanından tasarruf sağlar.
  Performans İyileştirme: Eski log dosyalarını arşivleyerek, sistem performansını ve dosya sistemlerinin yanıt sürelerini iyileştirir.
  Uyumluluk ve Denetim: Belirli bir saklama politikasına uygun olarak log dosyalarını yönetir. Bu, çeşitli düzenleyici ve yasal gerekliliklere uyumu sağlar.

Bu script, özellikle büyük ve karmaşık sistemlerde log yönetimini otomatikleştirmek ve sistem kaynaklarını daha etkin kullanmak için tasarlanmıştır. Eski dosyaların otomatik olarak sıkıştırılması ve yönetilmesi, manuel müdahale gereksinimini azaltır ve süreçleri daha verimli hale getirir.
