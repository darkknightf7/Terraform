resource "aws_cloudwatch_event_rule" "json_import_lambda_every_1_hour" {

  name                = "pathfinder-json-import-lambda-every-1-hour-dev"

  description         = "json-import lambda runs every 1 hour"

  schedule_expression = "rate(1 hour)"

  tags = {

    Name = "client-pathfinder"

    Environment = "Dev"

  }

}

resource "aws_cloudwatch_event_target" "cron_every_1_hour" {

  rule      = aws_cloudwatch_event_rule.json_import_lambda_every_1_hour.name

  target_id = "pathfinder-json-import-lambda-dev"

  arn       = aws_lambda_function.lambda_function["json-import"].arn

}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_json-import_lambda" {

  statement_id  = "AllowExecutionFromCloudWatch"

  action        = "lambda:InvokeFunction"

  function_name = aws_lambda_function.lambda_function["json-import"].function_name

  principal     = "events.amazonaws.com"

  source_arn    = aws_cloudwatch_event_rule.json_import_lambda_every_1_hour.arn

}

resource "aws_cloudwatch_query_definition" "filter_errors_for_import_lambda_dev" {

  name = "pathfinder_queries_dev/filter_errors_for_import_lambda_dev"

  log_group_names = [

    "/aws/lambda/client-pathfinder-json-import-lambda-dev"

  ]

  query_string = <<EOF

fields @timestamp, @message

| parse @message '"function_name":"*"' as function_name

| parse @message '"level":"*"' as level

| parse @message '"message":"*"' as message

| filter level = 'ERROR'

| sort @timestamp desc

| display @timestamp, function_name, level, message

EOF

}

resource "aws_cloudwatch_query_definition" "filter_errors_for_parser_lambda_dev" {

  name = "pathfinder_queries_dev/filter_errors_for_parser_lambda_dev"

  log_group_names = [

    "/aws/lambda/client-pathfinder-json-parser-lambda-dev"

  ]

  query_string = <<EOF

fields @timestamp, @message

| parse @message '"function_name":"*"' as function_name

| parse @message '"level":"*"' as level

| parse @message '"message":"*"' as message

| filter level = 'ERROR'

| sort @timestamp desc

| display @timestamp, function_name, level, message

EOF

}

resource "aws_cloudwatch_query_definition" "filter_info_for_parser_lambda_dev" {

  name = "pathfinder_queries_dev/filter_info_for_parser_lambda_dev"

  log_group_names = [

    "/aws/lambda/client-pathfinder-json-parser-lambda-dev"

  ]

  query_string = <<EOF

fields @timestamp, @message

| parse @message '"function_name":"*"' as function_name

| parse @message '"level":"*"' as level

| parse @message '"message":"*"' as message

| filter level = 'INFO'

| sort @timestamp desc

| display @timestamp, function_name, level, message

EOF

}

resource "aws_cloudwatch_query_definition" "filter_warning_for_parser_lambda_dev" {

  name = "pathfinder_queries_dev/filter_warning_for_parser_lambda_dev"

  log_group_names = [

    "/aws/lambda/client-pathfinder-json-parser-lambda-dev"

  ]

  query_string = <<EOF

fields @timestamp, @message

| parse @message '"function_name":"*"' as function_name

| parse @message '"level":"*"' as level

| parse @message '"message":"*"' as message

| filter level = 'WARNING'

| sort @timestamp desc

| display @timestamp, function_name, level, message

EOF

}

resource "aws_cloudwatch_query_definition" "query_new_imports_dev" {

  name = "pathfinder_queries_dev/query_new_imports_dev"

  log_group_names = [

    "/aws/lambda/client-pathfinder-json-import-lambda-dev"

  ]

  query_string = <<EOF

fields @timestamp, @message

| parse @message '"function_name":"*"' as function_name

| parse @message '"level":"*"' as level

| parse @message '"message":"*"' as message

| filter message like /Imported Json/

| filter level = 'INFO'

| sort @timestamp desc

| display @timestamp, function_name, level, message

EOF

}

resource "aws_cloudwatch_query_definition" "query_sent_emails_dev" {

  name = "pathfinder_queries_dev/query_sent_emails_dev"

  log_group_names = [

    "/aws/lambda/client-pathfinder-json-parser-lambda-dev"

  ]

  query_string = <<EOF

fields @timestamp, @message

| parse @message '"function_name":"*"' as function_name

| parse @message '"level":"*"' as level

| parse @message '"message":"*"' as message

| filter message like /Json processed/

| filter level = 'INFO'

| sort @timestamp desc

| display @timestamp, function_name, level, message

EOF

}
