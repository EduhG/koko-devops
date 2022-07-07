#!/bin/bash

sudo yum update -y && sudo yum install -y docker amazon-efs-utils
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker ec2-user
sudo chown root:docker /var/run/docker.sock