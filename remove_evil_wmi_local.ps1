foreach($server in Get-Content .\daftarserver.txt) {
  #Fill all target hostname without domain name in daftarserver.txt

  $Username = ''
  $Password = ''
  $pass = ConvertTo-SecureString -AsPlainText $Password -Force
  $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass  

  #kill Powershell process
  #WARNING! This will also kill legitimate powershell process
  #Invoke-Command -ComputerName $server -credential $credential {stop-process -Name powershell.exe}

  #kill WMI process
  Invoke-Command -ComputerName $server -credential $credential {stop-process -Name WmiPrvSE.exe}
  
  #remove malicious WMI class
  Invoke-Command -ComputerName $server -credential $credential {Remove-WmiObject -Namespace root\default -Class Win32_Services}
  
  #remove malicious __FilterToConsumerBinding instance
  Invoke-Command -ComputerName $server -credential $credential {Get-WmiObject __FilterToConsumerBinding -Namespace root\subscription | Where-Object {$_.filter -match 'DSM Event'} | Remove-WmiObject}

  #remove malicious __EventFilter instance
Invoke-Command -ComputerName $server -credential $credential {Get-WmiObject __EventFilter -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event'} | Remove-WmiObject}

  #remove malicious __CommandLineEventConsumer instance
Invoke-Command -ComputerName $server -credential $credential {Get-WmiObject CommandLineEventConsumer -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event'} | Remove-WmiObject}
}
