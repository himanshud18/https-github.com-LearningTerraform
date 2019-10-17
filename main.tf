# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "terraform-bucket-vijith-test"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "default" {
  ami                    = "${var.ami}"
  count                  = "${var.counts}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  source_dest_check      = false
  instance_type          = "${var.instance_type}"
  user_data = <<-EOF
  #! /bin/bash
      sudo yum -y install httpd
      sudo systemctl start httpd
      echo "<html><body style=background-color:powderblue;>Refinitiv Lab</body></html>" | sudo tee /var/www/html/index.html
    }

# Create Security Group for EC2
resource "aws_security_group" "default" {
  name = "terraform-default-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }    
}
