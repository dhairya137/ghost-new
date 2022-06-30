terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "ap-south-1"
  shared_credentials_file = "/home/dhairya/.aws/credentials"
}

provider "cloudflare" {
  email   = "dhairya00798@gmail.com"
  api_key = "a8e9e423a3b90864720a4c148b04ff30c9312"
}

data "cloudflare_zone" "dptools" {
  name = "dptools.me"
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
    Name : "${var.env_prefix}-sg"
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

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.dptools.id
  name    = "test2"
  value   = aws_eip.example
  type    = "A"
  proxied = true
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
    Name : "${var.env_prefix}-server"
  }
}


output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}

output "eip" {
  value = aws_eip.example.public_ip
}


output "domain_name" {
  value = cloudflare_record.www.name
}
output "domain_ip" {
  value = cloudflare_record.www.value
}
