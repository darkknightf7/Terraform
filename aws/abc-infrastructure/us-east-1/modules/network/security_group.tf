resource "aws_security_group" "client_mysql_sg" {
  name        = var.security_group_name
  description = "allows mysql access from client VPNs"

  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "TCP"
    cidr_blocks = [
      "Ip address"
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

