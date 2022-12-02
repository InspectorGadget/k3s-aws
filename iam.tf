# Create IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.name}-ec2-role"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
}

# Attach IAM Policy to role (Write file to S3)
resource "aws_iam_policy" "ec2_instance_role_policy" {
  depends_on = [
    aws_s3_bucket.k3sup_bucket
  ]

  name        = "${var.name}-ec2-policy"
  description = "Policy for EC2 Instance"

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:PutObjectTagging",
            "s3:PutObjectVersionAcl",
            "s3:PutObjectVersionTagging",
          ],
          Resource = [
            "arn:aws:s3:::${aws_s3_bucket.k3sup_bucket.id}/*",
            "arn:aws:s3:::${aws_s3_bucket.k3sup_bucket.id}"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy_attachment" "role_policy_attachment" {
  depends_on = [
    aws_iam_policy.ec2_instance_role_policy,
    aws_iam_role.ec2_instance_role
  ]

  name       = "${var.name}-ec2-policy-attachment"
  roles      = [aws_iam_role.ec2_instance_role.name]
  policy_arn = aws_iam_policy.ec2_instance_role_policy.arn
}

# Instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  depends_on = [
    aws_iam_role.ec2_instance_role
  ]

  name = "${var.name}-ec2-profile"
  role = aws_iam_role.ec2_instance_role.name
}
