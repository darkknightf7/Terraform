#Account wide IAM role for integration into Control Tower
resource "aws_iam_role" "AWSControlTowerExecution" {
  name                = "AWSControlTowerExecution"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::869706051743:root"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "Client"     = "client:client"
    "Managed By" = "Terraform"
    "Purpose"    = "AWS Control Tower Execution"
  }
}