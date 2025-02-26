resource "aws_sns_topic" "client_pagerduty" {
  name = "client-sns-topic"
}

data "aws_ssm_parameter" "client_pagerduty_subscription" {
  name = "client-pagerduty-subscription-endpoint"
}

data "aws_ssm_parameter" "client_xmatters_subscription" {
  name = "client-xmatters-subscription-endpoint"
}

resource "aws_sns_topic_subscription" "client_pagerduty_subscription" {
  topic_arn                       = aws_sns_topic.client_pagerduty.arn
  protocol                        = "https"
  endpoint                        = data.aws_ssm_parameter.client_pagerduty_subscription.value
  confirmation_timeout_in_minutes = 1
  endpoint_auto_confirms          = true
}

resource "aws_sns_topic_subscription" "client_xmatters_subscription" {
  topic_arn                       = aws_sns_topic.client_pagerduty.arn
  protocol                        = "https"
  endpoint                        = data.aws_ssm_parameter.client_xmatters_subscription.value
  confirmation_timeout_in_minutes = 1
  endpoint_auto_confirms          = true
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_utilization" {
  alarm_name          = "aurora-import-prod-CPU-utilization-breached-threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  datapoints_to_alarm = "3"
  treat_missing_data  = "missing"
  metric_name         = "CPUUtilization"
  namespace           = var.ec2_namespace
  period              = "300"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "CPU Utilization for aurora-import-prod instance running the import jobs has breached the threshold."
  actions_enabled     = var.actions_enabled
  alarm_actions       = [aws_sns_topic.client_pagerduty.arn]
  ok_actions          = [aws_sns_topic.client_pagerduty.arn]
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_instance_status_check" {
  alarm_name          = "aurora-import-prod-instance-status-check-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  datapoints_to_alarm = "1"
  treat_missing_data  = "missing"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = var.ec2_namespace
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Instance status check failure is detected by this alarm."
  actions_enabled     = var.actions_enabled
  alarm_actions       = [aws_sns_topic.client_pagerduty.arn]
  ok_actions          = [aws_sns_topic.client_pagerduty.arn]
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_system_status_check" {
  alarm_name          = "aurora-import-prod-system-status-check-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  datapoints_to_alarm = "1"
  treat_missing_data  = "missing"
  metric_name         = "StatusCheckFailed_System"
  namespace           = var.ec2_namespace
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "System status check detects issues with an instance's underlying hardware. Instance might need to be stopped and started again in order to resolve the issue."
  actions_enabled     = var.actions_enabled
  alarm_actions       = [aws_sns_topic.client_pagerduty.arn]
  ok_actions          = [aws_sns_topic.client_pagerduty.arn]
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "aurora_cpu_utilization" {
  alarm_name          = "aurora-mysql-prod-cluster-CPU-utilization-breached"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  datapoints_to_alarm = "3"
  treat_missing_data  = "missing"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm alerts when the CPU Utilization on the prod db server breached threshold."
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.client_pagerduty.arn]
  ok_actions          = [aws_sns_topic.client_pagerduty.arn]
  dimensions = {
    DBClusterIdentifier = "client-aurora-mysql-prod-cluster"
  }
}