# Create a system restore point
Checkpoint-Computer -Description "Debloat Windows 10 Backup"

# Create a backup of the current system
$date = Get-Date -Format yyyy-MM-dd
Backup-Computer -Description "Debloat Windows 10 Backup" -Path "C:\Windows10DebloatBackup_$date"

# Remove Windows 10 apps
Get-AppxPackage -AllUsers | Remove-AppxPackage

# Remove OneDrive
Remove-Item -Path "$env:SystemDrive\Users\$env:Username\OneDrive" -Recurse -Force
Remove-Item -Path "$env:SystemDrive\ProgramData\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force

# Remove Cortana
Remove-WindowsPackage -PackageName Microsoft.549981C3F5F10

# Remove Edge
Remove-WindowsPackage -PackageName Microsoft.MicrosoftEdge

# Remove Xbox App
Remove-WindowsPackage -PackageName Microsoft.XboxApp

# Remove Windows Store
Remove-WindowsPackage -PackageName Microsoft.WindowsStore

# Remove Windows Feedback
Remove-WindowsPackage -PackageName Windows Feedback

# Remove Windows Maps
Remove-WindowsPackage -PackageName Microsoft.WindowsMaps

# Optimize Ethernet connection
$NIC = Get-NetAdapter | where {$_.Status -eq "Up"}
$NIC | Disable-NetAdapter
Start-Sleep -s 10
$NIC | Enable-NetAdapter
$NIC | Set-NetAdapterAdvancedProperty -RegistryKeyword "*SpeedDuplex" -RegistryValue "0x10000"

# Optimize Network settings
# Change TcpAckFrequency
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" -Name "TcpAckFrequency" -Value "1" -PropertyType "DWORD" -Force

# Change TcpNoDelay
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" -Name "TcpNoDelay" -Value "1" -PropertyType "DWORD" -Force

# Disable Windows Telemetry
$telemetry = New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force
New-ItemProperty -Path $telemetry.PSPath -Name "AllowTelemetry" -Value "0" -PropertyType "DWord"

# Enable Dark mode
$darkmode = New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Force
New-ItemProperty -Path $darkmode.PSPath -Name "AppsUseLightTheme" -Value "0" -PropertyType "DWord"

# Run O&O Shutup10
Start-Process "C:\path\to\OOSu10.exe" -ArgumentList '/VERYSILENT /NORESTART'

