foreach($ip in Get-Content .\serverlist.txt) {
  #save all target IP in serverlist.txt
  echo "==================================="
  echo "Processing $ip ..."
  echo "==================================="
  
  #these lines are used to kill malicious process which can be identified by their command line
  wmic /node:$ip process WHERE "COMMANDLINE LIKE '%default:Win32_Services%'" CALL TERMINATE
  wmic /node:$ip process WHERE "COMMANDLINE LIKE '%info6.ps1%'" CALL TERMINATE

  wmic /node:$ip /NAMESPACE:"\\root\default" PATH Win32_Service DELETE
  wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter=""__EventFilter.Name='DSM Event Log Filter'""" DELETE
}
