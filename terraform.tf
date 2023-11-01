resource "aws_security_group" "ec2_computer_sg" {
  name        = "ec2_computer_sg_${var.aws_region}_${var.profile}"
  description = "Allow connection to ec2 computer in ${var.aws_region}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_computer_${var.aws_region}_${var.profile}"
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.profile
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20231025"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "aws_instance" "ec2_computer" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.web_ec2_type
  vpc_security_group_ids = [aws_security_group.ec2_computer_sg.id]
  key_name = var.key_name

  tags = {
    Name = "ec2_computer_${var.aws_region}_${var.profile}",
    System = "${var.web_ec2_type}",
  }

  root_block_device {
    delete_on_termination = "true"
  }
}

output "instance_public_ip_addr" {
  value = aws_instance.ec2_computer.public_ip
}

output "instance_type" {
  value = aws_instance.ec2_computer.instance_type
}

output "vpc_id" {
  value = aws_security_group.ec2_computer_sg.vpc_id
}