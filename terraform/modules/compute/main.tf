resource "aws_instance" "public_web" {
  ami                    = data.aws_ami.amazon_ami.id
  key_name               = "MyEC2KeyPair"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name        = "DemoPublicWebInstance"
    Environment = var.instance_env
    Access      = "public_instance"
  }
}

data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
