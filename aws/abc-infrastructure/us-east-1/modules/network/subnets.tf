resource "aws_subnet" "private_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block_private_subnet_1
  availability_zone = "us-east-1a"
  tags = {
    Name        = var.subnet_name_private_1
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block_private_subnet_2
  availability_zone = "us-east-1b"
  tags = {
    Name        = var.subnet_name_private_2
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block_public_subnet_1
  availability_zone = "us-east-1a"
  tags = {
    Name        = var.subnet_name_public_1
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name        = "aurora-subnet-group-${var.environment}"
  description = "subnet group for Aurora"
  subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

