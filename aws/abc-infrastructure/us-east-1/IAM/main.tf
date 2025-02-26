#Account wide IAM role for integration into Control Tower
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
  backend "s3" {
    bucket  = "client-data-tfstate"
    key     = "terraform-iam.tfstate"
    region  = "us-east-1"
    profile = "client"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "client"
  default_tags {
    tags = {
      Client = "client"
    }
  }
}
