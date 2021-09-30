provider "aws" {
  region = "ap-northeast-1"
}

variable "zone_name" {
  type = string
}

variable "webapp_1a_key_name" {
  type = string
}

variable "webapp_1a_ssh_public_key" {
  type = string
}

data "aws_ami" "ref_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_route53_zone" "webapp_app_dns" {
  name = var.zone_name
}

resource "aws_vpc" "webapp_net" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "grpc-samples-net"
  }
}

resource "aws_internet_gateway" "webapp_net_igw" {
  vpc_id = aws_vpc.webapp_net.id
  tags = {
    "Name" = "grpc-samples-igw"
  }
}

resource "aws_subnet" "webapp_net_public_1a" {
  vpc_id                  = aws_vpc.webapp_net.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "webapp_route_public" {
  vpc_id = aws_vpc.webapp_net.id
  tags = {
    "Name" = "grpc-samples-route-public"
  }
}

resource "aws_route" "webapp_route_public" {
  route_table_id         = aws_route_table.webapp_route_public.id
  gateway_id             = aws_internet_gateway.webapp_net_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "webapp_route_public_1a" {
  subnet_id      = aws_subnet.webapp_net_public_1a.id
  route_table_id = aws_route_table.webapp_route_public.id
}

resource "aws_security_group" "webapp_app_sg" {
  vpc_id = aws_vpc.webapp_net.id
  tags = {
    "Name" = "grpc-samples-webapp-sg"
  }
}

resource "aws_security_group_rule" "webapp_app_sg_in_ssh" {
  security_group_id = aws_security_group.webapp_app_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "webapp_app_sg_in_app" {
  security_group_id = aws_security_group.webapp_app_sg.id
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "webapp_app_sg_out" {
  security_group_id = aws_security_group.webapp_app_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_key_pair" "webapp_app_1a_key_name" {
  key_name   = var.webapp_1a_key_name
  public_key = var.webapp_1a_ssh_public_key
}

resource "aws_instance" "webapp_app_1a" {
  ami                    = data.aws_ami.ref_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.webapp_net_public_1a.id
  vpc_security_group_ids = [aws_security_group.webapp_app_sg.id]
  key_name               = aws_key_pair.webapp_app_1a_key_name.id
  tags = {
    "Name"             = "go-grpc-sample-webapp"
    "Application"      = "go-grpc-sample"
    "ApplicationGroup" = "webservers"
    "Stage"            = "production"
  }
}

resource "aws_route53_record" "webapp_app_dns" {
  zone_id = data.aws_route53_zone.webapp_app_dns.zone_id
  name    = data.aws_route53_zone.webapp_app_dns.name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.webapp_app_1a.public_ip]
  depends_on = [
    aws_instance.webapp_app_1a
  ]
}
