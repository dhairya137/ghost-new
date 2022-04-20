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

# Variable Definations
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}

# Create new VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

# Create new Subnet
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

# Create new Route Table
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  # Create routes
  route {
    # Handle Internet Gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id #? We don't have to define igw first. Terraform knows sequence of resources to create.
  }
  tags = {
    Name : "${var.env_prefix}-route-table"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name : "${var.env_prefix}-internet-gateway"
  }
}

# Subnet route table association
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

# Security Group
resource "aws_security_group" "myapp-sg" {
  name   = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  #? Incoming traffic from the world (means ssh into server or access the website from port 8080)
  ingress {
    from_port   = 22
    to_port     = 22 #We can range of ports at one time like from_port = 10, to_port = 1000, but here we want port 22 only
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # Who are allowed to access this port(Use own IP I am using it for testing)
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

  # Traffic from the server to the world
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1" # -1 means all protocols
    cidr_blocks     = [var.my_ip]
    prefix_list_ids = []
  }

  tags = {
    Name : "${var.env_prefix}-sg"
  }
}

# Get Amazon Linux AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    #? Above statement means AMI name should start with amzn-ami-hvm-  and end with   x86_64-gp2
  }
}

resource "aws_instance" "myapp-server" {
  #? Get AMI dynamically
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  #? This both are required to create an instance

  subnet_id              = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone      = var.avail_zone

  associate_public_ip_address = true #? Get public IP address
  key_name                    = "tf-key-pair"
  # key_name = "tf-kp"   # Created manually from console

  tags = {
    Name : "${var.env_prefix}-server"
  }
}

resource "null_resource" "example_provisioner" {
  triggers = {
    public_ip = aws_instance.myapp-server.public_ip
  }

  connection {
    type        = "ssh"
    host        = aws_instance.myapp-server.public_ip
    user        = "ubuntu"
    private_key = file("tf-key-pair.pem")
  }

  provisioner "file" {
    source      = "dc"
    destination = "dc"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x dc",
      "./dc setup new.dptools.me dhairya123@gmail.com"
    ]
  }

}


# Get EC2 instance public ip
output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}

