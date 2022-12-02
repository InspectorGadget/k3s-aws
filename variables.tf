variable "name" {
  description = "Name of the cluster"
  type        = string
}

variable "kubeconfig_bucket" {
  description = "S3 Bucket for Kubeconfig"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
