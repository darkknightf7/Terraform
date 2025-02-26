provider "aws" {

  region = "us-east-1"

}

terraform {

  required_version = ">=1.2.0"

  required_providers {

    aws = {

      version = "~>4.0"

    }

  }

  backend "s3" {

    bucket         = "client-terraform-backend"

    key            = "terraform_pathfinder_dev.tfstate"

    dynamodb_table = "Client_PATHFINDER_terraform_locks"

    region         = "us-east-1"

  }

}
