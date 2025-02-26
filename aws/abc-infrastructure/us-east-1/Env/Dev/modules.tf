data "aws_default_tags" "aws" {}

module "aurora_mysql_dev" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name                   = "client-aurora-mysql-dev-cluster"
  engine                 = "aurora-mysql"
  engine_mode            = "provisioned"
  engine_version         = "8.0.mysql_aurora.3.05.2"
  storage_encrypted      = true
  master_username        = "root"
  create_monitoring_role = false

  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc-client-main.id
  db_subnet_group_name = module.network_dev.db_subnet_group
  vpc_security_group_ids = [
    module.network_dev.security_group,
    aws_security_group.ec2-rds-sg.id
  ]

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 8
    max_capacity = 64
  }

  instance_class = "db.serverless"
  instances = {
    one = {
      identifier          = "client-aurora-mysql-dev"
      publicly_accessible = false
    }
  }
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_cluster_parameter_group_dev.name
  tags                            = data.aws_default_tags.aws.tags
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group_dev" {
  name        = "client-cluster-parameter-gp-dev"
  family      = "aurora-mysql8.0"
  description = "RDS cluster parameter group dev"

  parameter {
    name  = "aws_default_s3_role"
    value = module.iam_dev.client-s3-role.arn
  }

}

module "iam_dev" {
  source                                   = "../../modules/IAM"
  client_s3_policy_name                    = "client-data-s3-policy-dev"
  client_s3_role_name                      = "client-data-s3-role-dev"
  client_ec2_s3_role_name                  = "client-data-ec2-s3-role-dev"
  client_ec2_s3_policy_name                = "client-data-ec2-s3-policy-dev"
  client_s3_role_association_db_identifier = "client-aurora-mysql-dev,aws_iam_role.client-s3-role.arn"
  client_ecs_service_policy                = "client-data-ecs-service-policy-dev"
  client_ecs_service_role                  = "client-data-ecs-service-role-dev"
  client_data_bucket                       = module.s3_dev.client_data_bucket
  db_cluster_identifier                    = "client-aurora-mysql-dev-cluster"
}

module "s3_dev" {
  source      = "../../modules/s3"
  bucket_name = "client-s3-data-dev"
  environment = "Dev"
}

module "network_dev" {
  source                      = "../../modules/network"
  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc-client-main.id
  cidr_block_private_subnet_1 = "172.10.2.0/28"
  cidr_block_private_subnet_2 = "172.10.3.0/28"
  cidr_block_public_subnet_1  = "172.10.1.0/28"
  subnet_name_private_2       = "client-private-subnet-dev-2"
  subnet_name_private_1       = "client-private-subnet-dev-1"
  subnet_name_public_1        = "client-public-subnet-dev-1"
  environment                 = "dev"
  internet_gateway            = data.terraform_remote_state.vpc.outputs.client-vpc-internet-gateway.id
  security_group_name         = "client-mysql-dev-sg"
}

