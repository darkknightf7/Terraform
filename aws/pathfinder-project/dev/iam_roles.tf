resource "aws_iam_role" "client-pathfinder-lambda-role" {

  name = "client-pathfinder-lambda-role-dev"

  assume_role_policy = jsonencode({

    Version = "2012-10-17",

    Statement = [

      {

        Effect = "Allow",

        Principal = {

          Service = "lambda.amazonaws.com"

        },

        Action = "sts:AssumeRole"

      },

    ]

  })

}

resource "aws_iam_policy" "client-pathfinder-lambda-policy" {

  name        = "client-pathfinder-lambda-policy-dev"

  description = "allows lambdas to access various aws resources"

  policy = jsonencode({

    Version = "2012-10-17",

    Statement = [

      {

        Effect = "Allow",

        Action = [

          "ec2:DescribeNetworkInterfaces",

          "ec2:CreateNetworkInterface",

          "ec2:DeleteNetworkInterface",

          "ec2:DescribeInstances",

          "ec2:AttachNetworkInterface",

          "secretsmanager:GetResourcePolicy",

          "secretsmanager:GetSecretValue",

          "secretsmanager:DescribeSecret",

          "secretsmanager:ListSecretVersionIds",

          "secretsmanager:ListSecrets",

          "logs:CreateLogGroup",

          "logs:CreateLogStream",

          "logs:PutLogEvents"

        ],

        Resource = "*"

      },

      {

        Effect = "Allow",

        Action = [

          "s3:*"

        ],

        Resource = [

          "${aws_s3_bucket.bucket2.arn}/*",

          "${aws_s3_bucket.bucket2.arn}",

          "${aws_s3_bucket.bucket1.arn}",

          "${aws_s3_bucket.bucket1.arn}/*"

        ]

      },

    ]

  })

}

resource "aws_iam_role_policy_attachment" "policy_attach" {

  role       = aws_iam_role.client-pathfinder-lambda-role.name

  policy_arn = aws_iam_policy.client-pathfinder-lambda-policy.arn

}

data "aws_iam_policy" "aws_xray_write_only_access" {

  arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"

}

resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {

  role       = aws_iam_role.client-pathfinder-lambda-role.name

  policy_arn = data.aws_iam_policy.aws_xray_write_only_access.arn

}
