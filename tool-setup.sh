#!/bin/bash

chmod u+x ./gdriveTreeGen.sh

current_dir=`pwd`

mkdir privesc

# No more prompts so the script will just run
export DEBIAN_FRONTEND=noninteractive

# Doing this first so that there is time for docker container to update network vulnerabilties while script runs
echo''
echo '[+] UPDATING PACKAGE LIST'
apt update

echo ''
echo '[+] CLONING RECONNOITRE'
git clone https://github.com/codingo/Reconnoitre.git

echo ''
echo '[+] INSTALLING RECONNOITRE'
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
cd Reconnoitre
python3 setup.py install

cd $current_dir

rm get-pip.py


echo''
echo '[+] CLONING EYEWITNESS'
git clone https://github.com/FortyNorthSecurity/EyeWitness

echo '[+] INSTALLING EYEWITNESS'
cd EyeWitness/setup
./setup.sh

cd $current_dir

echo ''
echo '[+] ADDING IMPACKET ALIAS'
echo "alias impacket='cd /usr/share/doc/python-impacket/examples'" >> ~/.bashrc
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


mkdir /usr/share/seclists/
mkdir /usr/share/seclists/Discovery/
mkdir /usr/share/seclists/Discovery/Web-Content/

cd ..
cp ./wordlists/CGIs.txt ./wordlists/common.txt /usr/share/seclists/Discovery/Web-Content/


echo ''
echo '[+] GETTING WINDOWS-EXPLOIT-SUGGESTER'
# Ensure X11 enabled
sed -i 's/#X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config 

echo ''
echo '[+] GETTING WINDOWS-EXPLOIT-SUGGESTER'
systemctl restart ssh

#install tmux
echo ''
echo '[+} INSTALLING TMUX'

echo ''
echo '[+] DOWNLOAD AND SETUP GDRIVE BINARY'
wget -O /usr/bin/gdrive https://github.com/gdrive-org/gdrive/releases/download/2.1.0/gdrive-linux-x64
chmod u+x /usr/bin/gdrive

gdrive about


