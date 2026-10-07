terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}
# terraform {
#   backend "s3" {
#     bucket       = "deepak-terraform-state-2026-tws"
#     key          = "terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }


provider "aws" {
  region = "ap-south-1"

}

## key pair

resource "aws_key_pair" "terra-key" {
  key_name   = "terra-key"
  public_key = file("terra-key-ec2.pub")
  tags = {
    Name = "terra-key"
    Environment = var.env
  }
}

# vpc and security group

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default-vpc"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    description = "allow HTTP traffic"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    description = "allow 8000 port traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}



## ec2 instance

resource "aws_instance" "my-tf-ec2" {
  for_each = tomap({
    dd_instance = "t2.nano"
  })

  key_name        = aws_key_pair.terra-key.key_name
  security_groups = [aws_security_group.allow_ssh.name]
  instance_type   = each.value
  ami             = "ami-01a00762f46d584a1"
  user_data       = file("install_nginx.sh")
  root_block_device {
    volume_size = var.env == "prod" ? 20 : var.default_root_volume_size
    volume_type = "gp2"
  }
  tags = {
    Name = each.key
    Environment = var.env
  }
}
