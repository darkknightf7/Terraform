resource "aws_s3_bucket" "client_data_bucket" {
  bucket = var.bucket_name
  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_cors_configuration" "client_data_bucket_cors" {
  bucket = aws_s3_bucket.client_data_bucket.id

  cors_rule {
    allowed_headers = []
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 0
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "client_data_bucket_encryption" {
  bucket = aws_s3_bucket.client_data_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "client_data_bucket_versioning" {
  bucket = aws_s3_bucket.client_data_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}