:: kill malicious powershell
wmic process WHERE "COMMANDLINE LIKE '%%default:Win32_Services%%'" CALL TERMINATE
wmic process WHERE "COMMANDLINE LIKE '%%info9.ps1%%'" CALL TERMINATE
wmic process WHERE "COMMANDLINE LIKE '%%info6.ps1%%'" CALL TERMINATE
wmic process WHERE "COMMANDLINE LIKE '%%info3.ps1%%'" CALL TERMINATE
wmic process WHERE "COMMANDLINE LIKE '%%JABzAHQAaQBtAGUAPQBbAEUAbgB2AGkAcgBvAG4AbQBlAG4AdABdADoAOgBUAG%%'" CALL TERMINATE

:: kill malicious executables
wmic process WHERE "ExecutablePath='C:\\ProgramData\\UpdateService\\UpdateService.exe'" CALL TERMINATE
wmic process WHERE "ExecutablePath='C:\\ProgramData\\AppCache\\16\\java.exe'" CALL TERMINATE
wmic process WHERE "ExecutablePath='C:\\ProgramData\\AppCache\\17_\\java.exe'" CALL TERMINATE
wmic process WHERE "ExecutablePath='C:\\ProgramData\\AppCache\\17\\java.exe'" CALL TERMINATE
wmic process WHERE "ExecutablePath='C:\\ProgramData\\AppCache\\18\\java.exe'" CALL TERMINATE

:: delete malicious files
WMIC path cim_datafile WHERE "path='C:\\ProgramData\\UpdateService\\UpdateService.exe'" delete
WMIC path cim_datafile WHERE "path='C:\\ProgramData\\AppCache\\17_\\java.exe'" delete
WMIC path cim_datafile WHERE "path='C:\\ProgramData\\AppCache\\17\\java.exe'" delete
WMIC path cim_datafile WHERE "path='C:\\ProgramData\\AppCache\\16\\java.exe'" delete
WMIC path cim_datafile WHERE "path='C:\\ProgramData\\AppCache\\18\\java.exe'" delete

:: delete malicious WMI instances
wmic /NAMESPACE:"\\root\default" Class Win32_Services DELETE
wmic /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE "Name LIKE 'DSM Event%%'" DELETE
wmic /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE "Name LIKE 'DSM Event%%'" DELETE
wmic /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter=\"__EventFilter.Name='DSM Event Log Filter'\"" DELETE
wmic /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE "Filter=\"__EventFilter.Name='DSM Event Logs Filter'\"" DELETE