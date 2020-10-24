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
echo '[+] FETCHING GOWITNESS'
wget https://github.com/sensepost/gowitness/releases/download/2.1.2/gowitness-2.1.2-linux-amd64

echo ''
echo '[+] FETCHING CRACKMAPEXEC'
wget https://github.com/byt3bl33d3r/CrackMapExec/releases/download/v5.1.1dev/cme-ubuntu-latest.4.zip
unzip cme-ubuntu-latest.4.zip

echo ''
echo '[+] FETCHING IMPACKET'
git clone https://github.com/SecureAuthCorp/impacket.git

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

# Ensure X11 enabled
sed -i 's/#X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config 
systemctl restart ssh

echo ''
echo '[+] GETTING WINDOWS-EXPLOIT-SUGGESTER'
wget -c https://raw.githubusercontent.com/AonCyberLabs/Windows-Exploit-Suggester/master/windows-exploit-suggester.py

#install tmux
echo ''
echo '[+] INSTALLING TMUX'
apt install tmux -y

cd ~

echo "##Quality of life stuff
set -g history-limit 10000
set -g allow-rename off
##Search Mode VI (default is emac)
set-window-option -g mode-keys vi
#Logging
run-shell /opt/tmux-logging/logging.tmux" >> .tmux.conf

git clone https://github.com/tmux-plugins/tmux-logging /opt/tmux-logging/

tmux source-file ~/.tmux.conf

#install vim
echo ''
echo '[+] INSTALLING VIM'
apt install vim -y

source ~/.bashrc
