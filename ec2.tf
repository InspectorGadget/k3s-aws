# Create Launch Template
resource "aws_launch_template" "k3sup_launch_template" {
  depends_on = [
    aws_security_group.k3s_sg,
    aws_s3_bucket.k3sup_bucket,
    aws_iam_instance_profile.ec2_instance_profile,
    aws_lb.k3s_server_lb
  ]

  name_prefix   = "${var.name}-launch-template"
  image_id      = data.aws_ami.linux2_ami.id
  instance_type = "t2.micro"

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_profile.arn
  }

  user_data = base64encode(
    templatefile(
      "${path.module}/bootstrap/user-data.sh",
      {
        KUBECONFIG_BUCKET = aws_s3_bucket.k3sup_bucket.id,
        K3S_NLB_DOMAIN    = aws_lb.k3s_server_lb.dns_name
      }
    )
  )

  vpc_security_group_ids = [
    aws_security_group.k3s_sg.id
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name} - Instance"
    }
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "k3sup_asg" {
  depends_on = [
    aws_lb_target_group.k3s_server_tg
  ]

  name_prefix         = "${var.name}-asg"
  min_size            = 0 # CHANGE
  max_size            = 0 # CHANGE
  desired_capacity    = 0 # CHANGE
  vpc_zone_identifier = data.aws_subnets.public_subnets.ids
  target_group_arns = [
    aws_lb_target_group.k3s_server_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.k3sup_launch_template.id
    version = "$Latest"
  }

  # Reduce warumup time
  default_cooldown          = 30
  health_check_grace_period = 30

  tag {
    key                 = "Name"
    value               = "${var.name} - Instance"
    propagate_at_launch = true
  }
  tag {
    key                 = "k3s.io/cluster/${var.name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
