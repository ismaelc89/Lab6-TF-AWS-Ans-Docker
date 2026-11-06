resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "demo_vpc"
  }
}

resource "aws_internet_gateway" "demo_ig" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo_ig"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_ec2_instance_type_offerings.t3_micro.locations[0]

  tags = {
    Name = "demo_public_subnet"
  }
}

resource "aws_route_table" "demo_public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_ig.id
  }

  tags = {
    Name = "demo_rt"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.demo_public_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}

data "aws_ec2_instance_type_offerings" "t3_micro" {
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  location_type = "availability-zone"
}
