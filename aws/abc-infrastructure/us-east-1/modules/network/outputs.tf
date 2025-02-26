output "subnet-public-1" {
  value = aws_subnet.public_subnet_1
}

output "subnet-private-1" {
  value = aws_subnet.private_subnet_1
}

output "subnet-private-2" {
  value = aws_subnet.private_subnet_2
}

output "db_subnet_group" {
  value = aws_db_subnet_group.aurora_subnet_group.id
}

output "security_group" {
  value = aws_security_group.client_mysql_sg.id
}
