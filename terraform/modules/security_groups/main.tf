resource "aws_security_group" "public_ec2_sg" {
  name        = "web_ec2_sg"
  description = "SG for public ec2"
  vpc_id      = var.vpc_id

  tags = {
    Name = "web_ec2_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80

  tags = {
    Name = "HTTP Access"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_cadvisor" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8081
  to_port           = 8081
}

resource "aws_vpc_security_group_ingress_rule" "allow_prometheus" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9090
  to_port           = 9090
}

resource "aws_vpc_security_group_ingress_rule" "allow_node_exporter" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9100
  to_port           = 9100
}

resource "aws_vpc_security_group_ingress_rule" "allow_grafana" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  to_port           = 3000
}
