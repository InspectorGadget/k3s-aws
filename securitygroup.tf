# SG for K3s
resource "aws_security_group" "k3s_sg" {
  name        = "k3s_sg"
  description = "Security Group for K3s"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s_sg"
  }
}
