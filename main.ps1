foreach($namaserver in Get-Content .\daftarserver.txt) {
  #kill WMI process
  Invoke-Command -ComputerName $namaserver {stop-process -Name WmiPrvSE.exe}
  
  #kill powershell process, to prevent malware creates new WMI class
  #WARNING! this command will also kill legitimate powershell process
  #Invoke-Command -ComputerName $namaserver {stop-process -Name powershell.exe}
  
  #remove malicious WMI class
  #change 'Win32_Services' to match your environment
  Invoke-Command -ComputerName $namaserver {Remove-WmiObject -Namespace root\default -Class Win32_Services}
  
  #remove malicious __EventFilter instance
  #change 'DSM Event Log Filter' to match your environment
Invoke-Command -ComputerName $namaserver {Get-WmiObject __EventFilter -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event Log Filter'} | Remove-WmiObject}

  #remove malicious CommandLineEventConsumer instance
  #change 'DSM Event Log Consumer' to match your environment
Invoke-Command -ComputerName $namaserver {Get-WmiObject CommandLineEventConsumer -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event Log Consumer'} | Remove-WmiObject}

  #remove malicious __FilterToConsumerBinding instance
  #change 'DSM Event Log Filter' to match your environment
  Invoke-Command -ComputerName $namaserver {Get-WmiObject __FilterToConsumerBinding -Namespace root\subscription | Where-Object {$_.filter -match 'DSM Event Log Filter'} | Remove-WmiObject}
}
