packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "learn-packer-linux-aws"
}

variable "username" {
  type    = string
  default = "${env("USER")}"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name                    = "${var.ami_prefix}-${local.timestamp}"
  instance_type               = "t3.small"
  region                      = "ap-southeast-2"
  vpc_id                      = "vpc-95c265f0"
  subnet_id                   = "subnet-278b2850"
  associate_public_ip_address = "true"
  source_ami_filter {
    filters = {
      name                = "ubuntu-minimal/images/hvm-ssd/ubuntu-jammy-22.04-amd64-minimal-20221027"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    creator = "${var.username}"
  }
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing Redis",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y redis-server",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  /*provisioner "shell" {
    execute_command = "{{.Vars}} sudo -E -S '{{.Path}}'"
    script          = "./install-basebox.sh"
  }*/
}
