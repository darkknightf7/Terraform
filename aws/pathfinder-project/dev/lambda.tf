locals {

  lambda_config = {

    json-import = {

      "function_name"       = "client-pathfinder-json-import-lambda-dev"

      "filename"            = "../json-import.zip"

      "handler"             = "json-import.handler"

      "subnet_ids"          = []

      "security_groups_ids" = []

      "variables" = { SECRET_MANAGER_NAME = "arn:aws:secretsmanager:us-east-1:1212112121:secret:PATHFINDER-SECRETS-PzMJcO"

        ENVIRONMENT               = "DEVELOPMENT"

        INTERNAL_EXTERNAL_S3_NAME = "client-pathfinder-external-bucket"

        INTERNAL_INTERNAL_S3_NAME = "client-pathfinder-internal-bucket"

        DEV_TIME_KEY              = "content/dev_time.txt"

        PROD_TIME_KEY             = "content/prod_time.txt"

      }

    },

    json-parser = {

      "function_name"       = "client-pathfinder-json-parser-lambda-dev"

      "filename"            = "../json-parser.zip"

      "handler"             = "json-parser.handler"

      "subnet_ids"          = ["subnet-dadsad", "subnet-dasdas"]

      "security_groups_ids" = ["sg-dasdas"]

      "variables" = { SECRET_MANAGER_NAME = "arn:aws:secretsmanager:us-east-1:312312231123:secret:PATHFINDER-SECRETS-PzMJcO"

        ENVIRONMENT    = "DEVELOPMENT"

        DEV_EMAIL_LIST = "1212@test.com"

      }

    }

  }

  lambda_layers = {

    aws-lambda-powertools-python-layer = {

      "filename"                 = "../aws-lambda-powertools-python-layer.zip"

      "layer_name"               = "aws-lambda-powertools-python-layer-dev"

      "compatible_runtimes"      = ["python3.7", "python3.8", "python3.9"]

      "compatible_architectures" = []

      "description"              = "AWS Lambda Layer for aws-lambda-powertools version 2.4.0"

      "license_info"             = "Available under the Apache-2.0 license."

    },

    python_jinja2_layer = {

      "filename"                 = "../python_jinja2_layer.zip"

      "layer_name"               = "python_jinja2_layer_dev"

      "compatible_runtimes"      = []

      "compatible_architectures" = ["arm64", "x86_64"]

      "description"              = ""

      "license_info"             = ""

    }

  }

  runtime = "python3.9"

}

resource "aws_lambda_function" "lambda_function" {

  for_each = local.lambda_config

  function_name    = each.value.function_name

  role             = aws_iam_role.client-pathfinder-lambda-role.arn

  handler          = each.value.handler

  filename         = each.value.filename

  source_code_hash = filebase64sha256(each.value.filename)

  runtime          = local.runtime

  memory_size      = 128

  publish          = true

  timeout          = 60

  layers = ["arn:aws:lambda:us-east-1:3123123312:layer:AWSSDKPandas-Python39:1", aws_lambda_layer_version.lambda_layer["aws-lambda-powertools-python-layer"].arn,

  aws_lambda_layer_version.lambda_layer["python_jinja2_layer"].arn]

  tracing_config {

    mode = "Active"

  }

  vpc_config {

    subnet_ids         = each.value.subnet_ids

    security_group_ids = each.value.security_groups_ids

  }

  environment {

    variables = each.value.variables

  }

  tags = {

    Name = "client-pathfinder"

    Environment = "Dev"

  }

}

resource "aws_lambda_layer_version" "lambda_layer" {

  for_each                 = local.lambda_layers

  filename                 = each.value.filename

  layer_name               = each.value.layer_name

  description              = each.value.description

  source_code_hash         = filebase64sha256(each.value.filename)

  compatible_runtimes      = each.value.compatible_runtimes

  compatible_architectures = each.value.compatible_architectures

  license_info             = each.value.license_info

}

resource "aws_lambda_permission" "allow_bucket" {

  statement_id  = "AllowExecutionFromS3Bucket"

  action        = "lambda:InvokeFunction"

  function_name = aws_lambda_function.lambda_function["json-parser"].arn

  principal     = "s3.amazonaws.com"

  source_arn    = aws_s3_bucket.bucket2.arn

}

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = aws_s3_bucket.bucket2.id

  lambda_function {

    lambda_function_arn = aws_lambda_function.lambda_function["json-parser"].arn

    events              = ["s3:ObjectCreated:Put"]

    filter_prefix       = "new/"

    filter_suffix       = ".json"

  }

  depends_on = [aws_lambda_permission.allow_bucket]

}
