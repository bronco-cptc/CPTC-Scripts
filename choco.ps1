:: Install choco .exe and add choco to PATH
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:: Install all the packages
choco install mobaxterm -fy
choco install googlechrome -fy
choco install firefox -fy
choco install jre8 -fy
choco install zap -fy
choco install winscp -fy
choco install vlc -fy
choco install 7zip.install -fy
choco install wireshark -fy
choco install python3 --pre -fy
choco install python2 -fy
choco install nmap -fy
choco install sublimetext3 -fy
choco install greenshot -fy
choco install git.install -fy
choco install burp-suite-free-edition -fy
