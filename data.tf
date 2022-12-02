# Get current region
data "aws_region" "current" {}

# Find latest Amazon Linux 2 AMI
data "aws_ami" "linux2_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# Find the VPC
data "aws_vpc" "main_vpc" {
  id = var.vpc_id
}

# Find public subnets
data "aws_subnets" "public_subnets" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.main_vpc.id
    ]
  }

  filter {
    name   = "tag:Name"
    values = ["*Public*"]
  }
}
