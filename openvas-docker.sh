#!/bin/bash

echo ''
echo '[+] INSTALLING DOCKER'
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo 'deb https://download.docker.com/linux/debian stretch stable' > /etc/apt/sources.list.d/docker.list

apt-get update

sudo apt-get install -y docker docker-ce docker-ce-cli containerd.io

echo ''
echo '[+] STARTING OPENVAS CONTAINER'
docker run -d -p 443:443 -e OV_UPDATE=yes --name openvas atomicorp/openvas

echo ''
echo ' OPENVAS STARTED! ' 
echo ' https://<yourip>/ '
echo ' Default login / password: admin / admin'
