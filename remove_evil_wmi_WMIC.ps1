foreach($servername in Get-Content .\daftarserver.txt) {

  echo "==================================="
  echo "Processing $servername ..."
  echo "==================================="
  
  #these lines are used to kill malicious process which can be identified by their command line
  wmic /node:$servername process WHERE "COMMANDLINE LIKE '%default:Win32_Services%'" CALL TERMINATE
  wmic /node:$servername process WHERE "COMMANDLINE LIKE '%info6.ps1%'" CALL TERMINATE

  wmic /node:$servername /NAMESPACE:"\\root\default" PATH Win32_Service DELETE
  wmic /node:$servername /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$servername /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$servername /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter LIKE 'DSM Event%'" DELETE
}
