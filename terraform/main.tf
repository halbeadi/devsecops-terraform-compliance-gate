provider "aws" {
  region = "us-east-1"
}

# 1. INSECURE S3 BUCKET (Missing encryption, public access allowed, no logging)
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-company-vulnerable-audit-logs-bucket"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.vulnerable_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2. INSECURE SECURITY GROUP (Open SSH port to the entire world)
resource "aws_security_group" "allow_ssh_all" {
  name        = "allow_ssh_all"
  description = "Insecure security group allowing SSH from anywhere"
  vpc_id      = "vpc-12345678"

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
