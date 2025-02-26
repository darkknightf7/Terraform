# Bastion Host Setup
#-------------------
resource "aws_instance" "bastion_host" {
  ami                  = "image_id" #Amazon Linux 2023
  instance_type        = "t2.nano"
  iam_instance_profile = aws_iam_instance_profile.ec2_rds_profile.name
  subnet_id            = module.network_dev.subnet-public-1.id
  vpc_security_group_ids = [
    aws_security_group.client_ssh.id,
    aws_security_group.ec2-rds-sg.id
  ]

  tags = {
    Name = "client-bastion"
  }
}

#elastic ip for the Bastion Host
resource "aws_eip" "bastion_host_eip" {
  domain   = "vpc"
  instance = aws_instance.bastion_host.id
}

resource "aws_iam_instance_profile" "ec2_rds_profile" {
  name = "client-rds-ec2-profile"
  role = aws_iam_role.client-ec2-rds-role.name
}

resource "aws_iam_role" "client-ec2-rds-role" {
  name = "EC2-RDS-Access-Role"

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

resource "aws_iam_policy" "client-ec2-rds-policy" {
  name = "EC2-RDS-Access-Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ],
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "policy_attach_4" {
  role       = aws_iam_role.client-ec2-rds-role.name
  policy_arn = aws_iam_policy.client-ec2-rds-policy.arn
}


