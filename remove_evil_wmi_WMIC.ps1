foreach($ip in Get-Content .\daftarserver.txt) {
  Write-Output "===================================" 
  Write-Output "Processing $ip ..." 
  Write-Output "==================================="  
  
  $wmi = gwmi win32_bios -ComputerName $ip -ErrorAction SilentlyContinue

  if ($wmi)
  {
      Write-Host "Connection on computer $ip successful." -ForegroundColor DarkGreen;

      #these lines are used to kill malicious process which can be identified by their command line or path
      wmic /node:$ip process WHERE "COMMANDLINE LIKE '%default:Win32_Services%'" CALL TERMINATE
      wmic /node:$ip process WHERE "COMMANDLINE LIKE '%info6.ps1%'" CALL TERMINATE
      wmic /node:$ip process WHERE "ExecutablePath='C:\\ProgramData\\UpdateService.exe'" CALL TERMINATE
      wmic /node:$ip process WHERE "ExecutablePath='C:\\ProgramData\\AppCache\\17_\\java.exe'" CALL TERMINATE
      wmic /node:$ip process WHERE "ExecutablePath='C:\\ProgramData\\AppCache\\16\\java.exe'" CALL TERMINATE
      wmic /node:$ip process WHERE "COMMANDLINE LIKE '%JABzAHQAaQBtAGUAPQBbAEUAbgB2AGkAcgBvAG4AbQBlAG4AdABdADoAOgBUAG%'" CALL TERMINATE

      #delete all malicious files
      WMIC /node:$ip path cim_datafile WHERE "path='C:\\ProgramData\\UpdateService.exe'" delete
      WMIC /node:$ip path cim_datafile WHERE "path='C:\\ProgramData\\AppCache\\17_\\java.exe'" delete
      WMIC /node:$ip path cim_datafile WHERE "path='C:\\ProgramData\\AppCache\\16\\java.exe'" delete

      #change "Win32_Services" and "DSM Event" to match evil class and instance name found in your environment
      wmic /node:$ip /NAMESPACE:"\\root\default" PATH Win32_Services DELETE
      wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE "Name LIKE 'DSM Event%'" DELETE
      wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE "Name LIKE 'DSM Event%'" DELETE
      wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter=""__EventFilter.Name='DSM Event Log Filter'""" DELETE
      wmic /node:$ip /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter=""__EventFilter.Name='DSM Event Logs Filter'""" DELETE

  } else {Write-Host "Computer $ip RPC error" -ForegroundColor DarkRed;}
}
