# WannaMineCleaner
Remove all WMI instances and class of WannaMine malware.

In my environment, this malware use the following malicious name:
- **Win32_Services**, this malicious class was found in root\default namespace
- **DSM Event Log Consumer**, this malicious instance was found in root\subscription namespace
- **DSM Event Log Filter**, this malicious instance was found in root\subscription namespace


# Step 1

Find the name of malicious Class and instance. You can use the following script to find the name of malicious Class and instances.
```
wmic/namespace:\\root\subscription PATH __EventConsumer get/format:list

wmic/namespace:\\root\subscription PATH __EventFilter get/format:list

wmic/namespace:\\root\subscription PATH __FilterToConsumerBinding get/format:list

wmic/namespace:\\root\subscription PATH __TimerInstruction get/format:list
```

If your already have the script file used by malware, you can review the source code manually to find the name of malicious class.

To decode the script you can use online service like https://www.base64decode.org/

Here are some example found in my environment:

### EventConsumer

![Payload EventConsumer](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_EventConsumer.png)

To easily copy encoded payload, you can save the output directly to a file using this command:
```
wmic/namespace:\\root\subscription PATH __EventConsumer get/format:list > payload.txt
```

Bottom part of EventConsumer content
![Payload EventConsumer2](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_EventConsumer2.png)

### EventFilter
![Payload EventFilter](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_EventFilter.png)

### FilterToConsumerBinding
![Payload FilterToConsumerBinding](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_FilterToConsumerBinding.png)

# Step 2

Modify WannaMineCleaner script to match the malicous class and instance name in your environment.

# Step 3

Prepare the list of target servers, save them in *daftarserver.txt* (you can choose other name, but make sure to modify the WannaMineCleaner.

For example:
```
servername1.yourdomainname
servername2.yourdomainname
servername3.yourdomainname
```

# Step 4

Run *main.ps1* in one of domain member PC. Make sure you have sufficient access to those servers.
