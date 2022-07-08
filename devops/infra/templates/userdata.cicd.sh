#!/bin/bash

sudo yum update -y && sudo yum install -y wget git python-boto3 docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker ec2-user
sudo chown root:docker /var/run/docker.sock

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo amazon-linux-extras install -y java-openjdk11
sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

sudo amazon-linux-extras install -y ansible2

cat > /home/ec2-user/.ssh/aws-key <<EOF
${private_key}
EOF

sudo chmod 400 /home/ec2-user/.ssh/aws-key

mkdir -p /home/ec2-user/.aws/

cat > /home/ec2-user/.aws/config <<EOF
[default]
region = ${region}
EOF

cat > /home/ec2-user/.aws/credentials <<EOF
[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_secret_access_key}
EOF

sudo chown ec2-user: /home/ec2-user/.ssh/aws-key
sudo chown ec2-user: /home/ec2-user/.aws/credentials
sudo chown ec2-user: /home/ec2-user/.aws/config

sudo cp -r /home/ec2-user/.ssh /var/lib/jenkins
sudo cp -r /home/ec2-user/.aws /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl
