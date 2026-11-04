provider "aws" {
  region = "us-east-1"
}

# 1. SECURE S3 BUCKET (Encrypted, public access blocked)
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-company-secure-audit-logs-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "secure_bucket_public_block" {
  bucket                  = aws_s3_bucket.secure_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. SECURE SECURITY GROUP (Restricted ingress)
resource "aws_security_group" "allow_restricted" {
  name        = "allow_restricted"
  description = "Restricted security group"
  vpc_id      = "vpc-12345678"

  ingress {
    description = "Allow SSH only from internal corporate CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
