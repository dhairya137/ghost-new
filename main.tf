terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "ap-south-1"
  shared_credentials_file = "/home/dhairya/.aws/credentials"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}

resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.my_ip]
    prefix_list_ids = []
  }

  tags = {
    Name : "${var.env_prefix}-${timestamp()}-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_eip" "example" {
  instance = aws_instance.myapp-server.id
  vpc      = true
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # subnet_id              = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  # availability_zone      = var.avail_zone

  associate_public_ip_address = true
  key_name                    = "tf-key-pair"

  tags = {
    # Name : "${var.env_prefix}-server"
    Name : "${var.env_prefix}-${timestamp()}-server"
  }
}


output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}

output "eip" {
  value = aws_eip.example.public_ip
}
