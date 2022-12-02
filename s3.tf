# Create Config Bucket for Kubeconfig
resource "aws_s3_bucket" "k3sup_bucket" {
  bucket = var.kubeconfig_bucket
  force_destroy = true

  tags = {
    Name        = "k3sup-bucket"
    Environment = "dev"
  }
}

# Set Bucket ACL
resource "aws_s3_bucket_acl" "k3sup_bucket_acl" {
  depends_on = [
    aws_s3_bucket.k3sup_bucket
  ]

  bucket = aws_s3_bucket.k3sup_bucket.id
  acl    = "private"
}
