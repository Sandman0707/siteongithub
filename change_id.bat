@echo off
:: Меняем Machine GUID
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography /v MachineGuid /f
powershell -Command "[guid]::NewGuid().ToString() | Set-Content -Path 'HKLM:\SOFTWARE\Microsoft\Cryptography\MachineGuid'"

echo [INFO] Machine GUID изменён!

:: Меняем MAC-адрес (адаптер Ethernet)
setlocal enabledelayedexpansion
set /a num=10 + %random% %% 246
set MAC=00:%random:~0,2%:%random:~0,2%:%random:~0,2%:%random:~0,2%:%num%
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001" /v NetworkAddress /t REG_SZ /d %MAC% /f

echo [INFO] MAC-адрес изменён на %MAC%!

:: Меняем серийный номер жёсткого диска (для VirtualBox)
wmic diskdrive where "DeviceID='\\\\.\\PHYSICALDRIVE0'" call set SerialNumber="%random%%random%"

echo [INFO] Серийный номер жёсткого диска изменён!

:: Меняем серийный номер процессора (виртуально)
powershell -Command "Get-WmiObject -Query 'Select * from Win32_Processor' | ForEach-Object { $_.ProcessorId = ('{0:X}' -f (Get-Random -Minimum 100000 -Maximum 999999)) }"

echo [INFO] Серийный номер процессора изменён!

echo [INFO] Все изменения применены! Перезагрузите ВМ для обновления данных.
pause
