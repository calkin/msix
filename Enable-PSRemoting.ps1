Enable-PSRemoting -Force -SkipNetworkProfileCheck  

New-NetFirewallRule -Name "Allow WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled  True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP

$thumbprint = (New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My -KeyExportPolicy NonExportable).Thumbprint

$command = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$env:computername"";CertificateThumbprint=""$thumbprint""}"

cmd.exe /C $command

Export-Certificate -Cert Cert:\LocalMachine\My\$thumbprint -FilePath "C:\cert\PSRemoting.cert"

Import-Certificate -FilePath "C:\cert\PSRemoting.cert" -CertStoreLocation Cert:\LocalMachine\Root

