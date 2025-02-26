terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
  backend "s3" {
    # bucket         = "client-data-tfstate"
    bucket         = "client-terraform-states"
    key            = "client/vpc/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "client_terraform_locks"
    # profile        = "client_DevOps_Tools"
  }
}

provider "aws" {
  region = "us-east-1"
  # profile = "client"
  assume_role {
    role_arn = "arn:aws:iam::${var.ACCOUNT_NUMBER}:role/system/codebuild-deploy-${var.ACCOUNT_NUMBER}"
  }
  default_tags {
    tags = {
      Client = "client"
    }
  }
}