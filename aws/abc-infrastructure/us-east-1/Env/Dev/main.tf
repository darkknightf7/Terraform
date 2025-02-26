terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
  backend "s3" {
    bucket  = "client-data-tfstate"
    key     = "dev_terraform.tfstate"
    region  = "us-east-1"
    profile = "client"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "client"
  default_tags {
    tags = {
      Environment = "Dev"
      Client      = "client"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "client-data-tfstate"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "client"
  }
}
