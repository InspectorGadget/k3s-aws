# Create NLB
resource "aws_lb" "k3s_server_lb" {
  name                             = "k3s-lb"
  load_balancer_type               = "network"
  internal                         = "false"
  enable_cross_zone_load_balancing = true
  subnets                          = data.aws_subnets.public_subnets.ids

  tags = {
    Name = "k3s-lb"
  }
}

# Create NLB Listener
resource "aws_lb_listener" "k3s_server_listener" {
  depends_on = [
    aws_lb.k3s_server_lb
  ]

  load_balancer_arn = aws_lb.k3s_server_lb.arn

  protocol = "TCP"
  port     = 6443

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s_server_tg.arn
  }
}

# Create Target Group for NLB
resource "aws_lb_target_group" "k3s_server_tg" {
  depends_on = [
    aws_lb.k3s_server_lb
  ]

  port     = 6443
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "TCP"
  }

  lifecycle {
    create_before_destroy = true
  }
}
