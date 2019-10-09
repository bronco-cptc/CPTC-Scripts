#!/bin/bash
#the basics
echo -e "alias ll='ls -lh'" >> ~/.bashrc
echo -e "alias ll='ls -lh'" >> ~/.bashrc
echo -e "alias la='ls -lha'" >> ~/.bashrc
echo -e "alias l='ls -CF'" >> ~/.bashrc
echo -e "alias grep='grep --color=auto'" >> ~/.bashrc
echo -e "alias fgrep='fgrep --color=auto'" >> ~/.bashrc
echo -e "alias egrep='egrep --color=auto'" >> ~/.bashrc
echo -e "alias ..='cd ..'" >> ~/.bashrc
echo -e "alias ...='cd ../../..'" >> ~/.bashrc
echo -e "alias psaux='ps aux | less'" >> ~/.bashrc
echo -e "alias netstat='netstat -tulanp'" >> ~/.bashrc
#actual stuff
echo -e "alias webserver='python -m SimpleHTTPServer'" >> ~/.bashrc
echo -e "alias wget='wget -c'" >> ~/.bashrc
echo -e "alias top='htop'" >> ~/.bashrc
#reload bashrc
source ~/.bashrc
