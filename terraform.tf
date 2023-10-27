provider "aws" {
  region                   = var.aws_region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.profile
}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Stream 8 x86_64 20230530"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["125523088429"]
}


resource "aws_instance" "ec2_computer" {
  ami = data.aws_ami.centos.id
  instance_type = var.web_ec2_type



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