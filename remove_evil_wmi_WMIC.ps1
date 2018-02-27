foreach($servername in Get-Content .\daftarserver.txt) {
  #Fill all target hostname without domain name in daftarserver.txt
  echo "==================================="
  echo "Processing $servername ..."
  echo "==================================="
  wmic /node:$servername process WHERE "COMMANDLINE LIKE '%Win32_Services%'" CALL TERMINATE
  wmic /node:$servername /NAMESPACE:"\\root\default" PATH Win32_Service DELETE
  wmic /node:$servername /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$servername /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE "Name LIKE 'DSM Event%'" DELETE
  wmic /node:$servername /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter LIKE 'DSM Event%'" DELETE
}
