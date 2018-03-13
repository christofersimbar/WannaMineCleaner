foreach($server in Get-Content .\daftarserver.txt) {
  #Fill all target hostname without domain name in daftarserver.txt

  $Username = ''
  $Password = ''
  $pass = ConvertTo-SecureString -AsPlainText $Password -Force
  $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass  

  #kill malicious processes identified by their command line
  #change 'Win32_Services' to match your environment
  Invoke-Command -ComputerName $namaserver {(Get-WmiObject win32_process -filter "CommandLine LIKE '%default:Win32_Services%'").Terminate()}
  Invoke-Command -ComputerName $namaserver {(Get-WmiObject win32_process -filter "CommandLine LIKE '%info6.ps1%'").Terminate()}
  Invoke-Command -ComputerName $namaserver {(Get-WmiObject win32_process -filter "CommandLine LIKE '%info3.ps1%'").Terminate()}
  Invoke-Command -ComputerName $namaserver {(Get-WmiObject win32_process -filter "CommandLine LIKE '%info9.ps1%'").Terminate()}
  Invoke-Command -ComputerName $namaserver {(Get-WmiObject win32_process -filter "CommandLine LIKE '%JABzAHQAaQBtAGUAPQBbAEUAbgB2AGkAcgBvAG4AbQBlAG4AdABdADoAOgBUAG%'").Terminate()}
  
  #remove malicious WMI class
  Invoke-Command -ComputerName $server -credential $credential {Remove-WmiObject -Namespace root\default -Class Win32_Services}
  
  #remove malicious __FilterToConsumerBinding instance
  Invoke-Command -ComputerName $server -credential $credential {Get-WmiObject __FilterToConsumerBinding -Namespace root\subscription | Where-Object {$_.filter -match 'DSM Event'} | Remove-WmiObject}

  #remove malicious __EventFilter instance
Invoke-Command -ComputerName $server -credential $credential {Get-WmiObject __EventFilter -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event'} | Remove-WmiObject}

  #remove malicious __CommandLineEventConsumer instance
Invoke-Command -ComputerName $server -credential $credential {Get-WmiObject CommandLineEventConsumer -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event'} | Remove-WmiObject}
}
