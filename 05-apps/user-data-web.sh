#!/bin/bash

#Set hosts
echo > /etc/hosts
cat <<EOF >> /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

EOF

# Set hostname
echo ${smtx-app} > /etc/hostname ; echo ${hostname} > /proc/sys/kernel/hostname ; export HOSTNAME="${hostname}"

# Install python|pip|Flask:
sudo yum update -y
sudo yum install python-virtualenv -y
sudo yum install python-pip
sudo pip install Flask
sudo yum -y install telnet

# Create Directory
sudo mkdir /app
cd /app

# Install Docker

sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo yum install git -y

cd /app/

sudo git clone https://github.com/mbaetaoliveira/flask.git

cd /flask/

docker-compose up -d
