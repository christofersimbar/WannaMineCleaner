foreach($namaserver in Get-Content .\daftarserver.txt) {
  #kill WMI process
  Invoke-Command -ComputerName $namaserver {stop-process -Name WmiPrvSE.exe}
  
  #remove malicious WMI class
  Invoke-Command -ComputerName $namaserver {Remove-WmiObject -Namespace root\default -Class Win32_Services}
  
  #remove malicious __FilterToConsumerBinding instance
  Invoke-Command -ComputerName $namaserver {Get-WmiObject __FilterToConsumerBinding -Namespace root\subscription | Where-Object {$_.filter -match 'DSM Event'} | Remove-WmiObject}

  #remove malicious __EventFilter instance
Invoke-Command -ComputerName $namaserver {Get-WmiObject __EventFilter -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event'} | Remove-WmiObject}

  #remove malicious __CommandLineEventConsumer instance
Invoke-Command -ComputerName $namaserver {Get-WmiObject CommandLineEventConsumer -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event'} | Remove-WmiObject}
}
