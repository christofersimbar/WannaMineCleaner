# WannaMineCleaner
Remove all WMI instances and class of WannaMine malware.

In my environment, this malware use the following malicious name:
**Win32_Services**, this malicious class was found in root\default namespace
**DSM Event Log Consumer**, this malicious instance was found in root\subscription namespace
**DSM Event Log Filter**, this malicious instance was found in root\subscription namespace


**Step 1**

Find the name of malicious Class and instance. You can use the following script to find the name of malicious Class and instances.
```
wmic/namespace:\\root\subscription PATH __EventConsumer get/format:list

wmic/namespace:\\root\subscription PATH __EventFilter get/format:list

wmic/namespace:\\root\subscription PATH __FilterToConsumerBinding get/format:list

wmic/namespace:\\root\subscription PATH __TimerInstruction get/format:list
```

If your already have the script file used by malware, you can review the source code manually to find the name of malicious class.
To decode the script you can use online service like https://www.base64decode.org/


**Step 2**

Modify WannaMineCleaner script to match the malicous class and instance name in your environment.

**Step 3**

Prepare the list of target servers, saved them in daftarserver.txt (you can choose other name, but make sure to modify the WannaMineCleaner. For example:
```
servername1.yourdomainname
servername2.yourdomainname
servername3.yourdomainname
```

**Step 4**

Run the WannaMineCleaner in one of domain member PC. Make sure you have sufficient access to those servers.
