foreach($ip in Get-Content .\serverlist.txt) {
  #save all target IP in serverlist.txt
  Write-Output "==================================="
  Write-Output "Processing $ip ..."
  Write-Output "==================================="
  
  #these lines are used to kill malicious process which can be identified by their command line
  wmic /node:$ip process WHERE "COMMANDLINE LIKE '%default:Win32_Services%'" CALL TERMINATE
  wmic /node:$ip process WHERE "COMMANDLINE LIKE '%info6.ps1%'" CALL TERMINATE

  wmic /node:$ip /NAMESPACE:"\\root\default" PATH Win32_Services DELETE
  wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter=""__EventFilter.Name='DSM Event Log Filter'""" DELETE
}
