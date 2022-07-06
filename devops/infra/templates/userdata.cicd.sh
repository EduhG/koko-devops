#!/bin/bash

sudo yum update -y && sudo yum install -y wget python3-pip
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo amazon-linux-extras install -y ansible2 python-boto3

cat > ~/.ssh/aws-key <<EOF
${private_key}
EOF

chmod 400 ~/.ssh/aws-key
ssh-agent bash
ssh-add ~/.ssh/aws-key

cat > ~/.aws/config <<EOF
[default]
region = ${region}
EOF

cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_secret_access_key}
EOF
