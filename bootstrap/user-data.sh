#!/bin/bash -e

# Install unzip on Amazon Linux 2
yum install -y unzip

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

mkdir -p /home/ec2-user/.kube
chown -R ec2-user:ec2-user /home/ec2-user/.kube

# Get Node IP from EC2 metadata
NODE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Install K3s
curl -sfL https://get.k3s.io | sh -s - --cluster-init --write-kubeconfig-mode 644 --write-kubeconfig /home/ec2-user/.kube/config --node-ip $NODE_IP --advertise-address $NODE_IP --tls-san ${K3S_NLB_DOMAIN}

# Edit kubeconfig to use NLB domain
sed -i "s/127.0.0.1/${K3S_NLB_DOMAIN}/g" /home/ec2-user/.kube/config

# Upload kubeconfig to S3
aws s3 cp /home/ec2-user/.kube/config s3://${KUBECONFIG_BUCKET} --metadata-directive REPLACE