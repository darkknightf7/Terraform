resource "aws_s3_bucket" "bucket1" {

  bucket = "client-pathfinder-external-bucket-dev"

  tags = {

    Name = "client-pathfinder"

    Environment = "Dev"

  }

}

resource "aws_s3_bucket_acl" "bucket1_acl" {

  bucket = aws_s3_bucket.bucket1.id

  acl    = "private"

}

resource "aws_s3_bucket_cors_configuration" "bucket1_cors" {

  bucket = aws_s3_bucket.bucket1.id

  cors_rule {

    allowed_headers = []

    allowed_methods = ["GET"]

    allowed_origins = ["*"]

    expose_headers  = []

    max_age_seconds = 0

  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket1_encryption" {

  bucket = aws_s3_bucket.bucket1.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

resource "aws_s3_bucket_versioning" "bucket1_versioning" {

  bucket = aws_s3_bucket.bucket1.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_bucket" "bucket2" {

  bucket = "client-pathfinder-internal-bucket-dev"

  tags = {

    Name = "client-pathfinder"

    Environment = "Dev"

  }

}

resource "aws_s3_bucket_acl" "bucket2_acl" {

  bucket = aws_s3_bucket.bucket2.id

  acl    = "private"

}

resource "aws_s3_bucket_cors_configuration" "bucket2_cors" {

  bucket = aws_s3_bucket.bucket2.id

  cors_rule {

    allowed_headers = []

    allowed_methods = ["GET"]

    allowed_origins = ["*"]

    expose_headers  = []

    max_age_seconds = 0

  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket2_encryption" {

  bucket = aws_s3_bucket.bucket2.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

resource "aws_s3_bucket_versioning" "bucket2_versioning" {

  bucket = aws_s3_bucket.bucket2.id

  versioning_configuration {

    status = "Enabled"

  }

}
