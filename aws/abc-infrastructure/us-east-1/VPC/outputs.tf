output "vpc-client-main" {
  value = aws_vpc.client_main
}

output "client-vpc-internet-gateway" {
  value = aws_internet_gateway.igw
}