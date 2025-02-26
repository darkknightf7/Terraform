#nat gateway
resource "aws_eip" "nat1" {
}

resource "aws_nat_gateway" "primary" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "${var.environment}-nat-Public",
    Env  = var.environment
  }
}
