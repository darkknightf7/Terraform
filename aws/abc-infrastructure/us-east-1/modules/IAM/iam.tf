resource "aws_iam_policy" "client-s3-policy" {
  name = var.client_s3_policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowAuroraToS3",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:AbortMultipartUpload",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:ListMultipartUploadParts"
        ],
        "Resource" : [
          "${var.client_data_bucket}/*",
          "${var.client_data_bucket}"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "client-s3-role" {
  name = var.client_s3_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "rds.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_rds_cluster_role_association" "client_s3_role" {
  db_cluster_identifier = var.db_cluster_identifier
  feature_name          = ""
  role_arn              = aws_iam_role.client-s3-role.arn
}


resource "aws_iam_role_policy_attachment" "policy_attach_1" {
  role       = aws_iam_role.client-s3-role.name
  policy_arn = aws_iam_policy.client-s3-policy.arn
}

resource "aws_iam_role" "client-ec2-s3-role" {
  name = var.client_ec2_s3_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "client-ec2-s3-policy" {
  name = var.client_ec2_s3_policy_name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "s3:AbortMultipartUpload",
          "s3:ListBucket",
          "s3:DeleteObject",
          "secretsmanager:ListSecretVersionIds",
          "s3:GetObjectVersion",
          "s3:ListMultipartUploadParts"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "policy_attach_3" {
  role       = aws_iam_role.client-ec2-s3-role.name
  policy_arn = aws_iam_policy.client-ec2-s3-policy.arn
}