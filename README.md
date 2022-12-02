# K3S on AWS with Terraform

**Note:** This is purely made for learning purposes. Any PRs are welcome.

## Introduction
K3S is a lightweight Kubernetes distribution that is easy to install and manage. It is a great option for small to medium sized clusters. This project is a Terraform module that will deploy a K3S cluster on AWS. It will inherit existing VPC, with their Subnets to create its own set of resources to run K3S on the Cloud. The following resources will be created:

* Network Load Balancer
* Security Groups
* Auto Scaling Group
* Launch Template
* IAM Role
* IAM Policy
* IAM Instance Profile
* EC2 Instances

## Prerequisites
* AWS account
* AWS CLI
* Terraform

## Usage
1. Clone this repository
2. Create a S3 Bucket manually in AWS for the Terraform State
3. Update the variables accordingly in `variables.tf`
4. Update the S3 Bucket name along with the AWS region accordingly in `backend.tf`
5. Change the region in `main.tf` if needed.
6. Run `terraform init`
7. Run `terraform plan`
8. Run `terraform apply`

## Notes
* The default instance type is `t2.micro`. You can change it to whatever you want.
* The default AMI is Amazon Linux 2 AMI. It is set to get the Latest Image by default.
* The default number of instances is 1. You can change it to whatever you want.
* ASG has been set to `0`. You can change it whenever you want to provision an instance.
* Kubeconfig generated from the K3S cluster will be saved in S3 bucket provided in the `variables.tf` file.

## For the future
* Add support for Spot Instances.