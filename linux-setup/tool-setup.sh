#!/bin/bash

# Create local structure 
mkdir /root/cptc
cd /root
current_dir=`pwd`

mkdir privesc

# No more prompts so the script will just run
export DEBIAN_FRONTEND=noninteractive


# Doing this first so that there is time for docker container to update network vulnerabilties while script runs
echo''
echo '[+] UPDATING PACKAGE LIST'
apt update

cd $current_dir

echo''
echo '[+] CLONING EYEWITNESS'
git clone https://github.com/FortyNorthSecurity/EyeWitness

echo '[+] INSTALLING EYEWITNESS'
cd EyeWitness/setup
./setup.sh

cd $current_dir

echo ''
echo '[+] ADDING IMPACKET ALIAS'
git clone https://github.com/SecureAuthCorp/impacket.git
. ~/.bashrc


echo ''
echo '[+] INSTALLING GOBUSTER'
apt-get install gobuster -y

cd $current_dir/privesc

echo ''
echo '[+] GETTING LINUXPRIVCHECKER.PY'
wget https://raw.githubusercontent.com/sleventyeleven/linuxprivchecker/master/linuxprivchecker.py

echo ''
echo '[+] GETTING WINDOWS-EXPLOIT-SUGGESTER'
wget https://raw.githubusercontent.com/GDSSecurity/Windows-Exploit-Suggester/master/windows-exploit-suggester.py


echo ''
echo '[+] GETTING WORDLISTS'
mkdir /usr/share/seclists/
mkdir /usr/share/seclists/Discovery/
mkdir /usr/share/seclists/Discovery/Web-Content/

cd $current_dir

cp ./wordlists/CGIs.txt ./wordlists/common.txt /usr/share/seclists/Discovery/Web-Content/

echo ''
echo '[+] GETTING WINDOWS-EXPLOIT-SUGGESTER'
# Ensure X11 enabled
sed -i 's/#X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config 
systemctl restart ssh

echo ''
echo '[+] GETTING WINDOWS-EXPLOIT-SUGGESTER'
wget -c https://raw.githubusercontent.com/AonCyberLabs/Windows-Exploit-Suggester/master/windows-exploit-suggester.py

#install tmux
echo ''
echo '[+} INSTALLING TMUX'
apt install tmux

source ~/.bashrc



