# WannaMineCleaner
Remove all WMI instances and class of WannaMine malware.

In my environment, this malware uses the following malicious name:
- **Win32_Services**, this malicious class was found in root\default namespace
- **DSM Event Log Consumer**, this malicious instance was found in root\subscription namespace
- **DSM Event Log Filter**, this malicious instance was found in root\subscription namespace


# Step 1

Find the name of malicious Class and instance. You can use the following command to find the name of malicious Class and instances.
```
wmic/namespace:\\root\subscription PATH __EventConsumer get/format:list

wmic/namespace:\\root\subscription PATH __EventFilter get/format:list

wmic/namespace:\\root\subscription PATH __FilterToConsumerBinding get/format:list

wmic/namespace:\\root\subscription PATH __TimerInstruction get/format:list
```

If you already have the script file used by malware, you can review the source code manually to find the name of malicious class.

To decode the script you can use online service like https://www.base64decode.org/

Here are some examples found in my environment:

### EventConsumer

![Payload EventConsumer](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_EventConsumer.png)

Bottom part of EventConsumer content
![Payload EventConsumer2](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_EventConsumer2.png)

To easily copy the encoded payload, you can save the output directly to a file using this command:
```
wmic/namespace:\\root\subscription PATH __EventConsumer get/format:list > payload.txt
```


### EventFilter
![Payload EventFilter](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_EventFilter.png)

### FilterToConsumerBinding
![Payload FilterToConsumerBinding](https://github.com/christofersimbar/WannaMineCleaner/blob/master/payload_FilterToConsumerBinding.png)

# Step 2

Modify *main.ps1* to match the malicous class and instance name in your environment.

In my environment this malware uses **Win32_Services** for its malicious class name. I found it by analyzing payload source code.
```
Invoke-Command -ComputerName $namaserver {Remove-WmiObject -Namespace root\default -Class Win32_Services}
```

For EventFilter instance name, this malware uses **DSM Event Log Filter**. Change this to the one you found in payload source code.
```
Invoke-Command -ComputerName $namaserver {Get-WmiObject __EventFilter -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event Log Filter'} | Remove-WmiObject}
```

For EventConsumer instance name, this malware uses **DSM Event Log Consumer**. Change this to the one you found in payload source code.
```
Invoke-Command -ComputerName $namaserver {Get-WmiObject CommandLineEventConsumer -Namespace root\subscription | Where-Object {$_.name -match 'DSM Event Log Consumer'} | Remove-WmiObject}
```

The last part is FilterToConsumerBinding instance name. Change **DSM Event Log Consumer** to match EventConsumer name. 
```
Invoke-Command -ComputerName $namaserver {Get-WmiObject __FilterToConsumerBinding -Namespace root\subscription | Where-Object {$_.filter -match 'DSM Event Log Consumer'} | Remove-WmiObject}
```

# Step 3

Prepare the list of target servers, save them in *daftarserver.txt* (you can choose other name, but make sure to modify the *main.ps1*).

For example:
```
servername1.yourdomainname
servername2.yourdomainname
servername3.yourdomainname
```

# Step 4

Run *main.ps1* in one of domain member PC. Make sure you have sufficient access to those servers.

# References
- http://la.trendmicro.com/media/misc/understanding-wmi-malware-research-paper-en.pdf
- https://www.crowdstrike.com/blog/cryptomining-harmless-nuisance-disruptive-threat/
- http://www.exploit-monday.com/2016/08/wmi-persistence-using-wmic.html
