resource "aws_security_group" "client_ssh" {
  name        = "client_ssh_prod"
  description = "Whitelists client VPNs"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc-client-main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    description = ""
    cidr_blocks = [
    ]
  }
}

resource "aws_security_group" "ec2-rds-sg" {
  name        = "ec2-rds-sg-prod"
  description = "Security group attached to instances to securely connect to client-aurora-mysql-prod. Modification could lead to connection loss."
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc-client-main.id

  egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "client-s3-ec2-profile-prod"
  role = module.iam_prod.client-ec2-s3-role.name
}

resource "aws_instance" "aurora_import_prod_instance" {
  ami                  = "image_id" #Aurora import image prod
  instance_type        = "t2.medium"
  subnet_id            = module.network_prod.subnet-public-1.id
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name
  vpc_security_group_ids = [
    aws_security_group.client_ssh.id,
    aws_security_group.ec2-rds-sg.id
  ]
  tags = {
    Name = "aurora-import-prod"
  }
}

resource "aws_ebs_volume" "aurora_import_prod" {
  availability_zone = "us-east-1a"
  size              = 30
}

############################################
#    For Bastion EIP Resources creation    #
############################################
resource "aws_eip" "aurora_import_prod_EIP" {
  vpc = true
  tags = {
    Name = "aurora-import-prod-EIP"
  }
}

######################################
#    Associate EIP to Bastion EC2    #
######################################
resource "aws_eip_association" "aurora_import_prod_eip_assoc" {
  instance_id   = aws_instance.aurora_import_prod_instance.id
  allocation_id = aws_eip.aurora_import_prod_EIP.id
}
