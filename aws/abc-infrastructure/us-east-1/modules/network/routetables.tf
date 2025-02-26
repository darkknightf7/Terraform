resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway
  }

  tags = {
    Name = "${var.environment}-default-route-public"
  }
}

resource "aws_route_table_association" "subnet-public1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_route_table" "private-routetable-1" {
  vpc_id = var.vpc_id


  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.primary.id
  }

  route {
    cidr_block                = "172.11.0.0/16"
    vpc_peering_connection_id = "pcx-0b144fdbc67309b03" #ACQUIA'S VPC PEERING CONNECTION
  }
  tags = {
    Name = "${var.environment}-route-table-private"
  }
}


resource "aws_route_table_association" "subnet-private1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private-routetable-1.id
}

resource "aws_route_table_association" "subnet-private2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private-routetable-1.id
}