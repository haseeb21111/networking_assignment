# Terraform script to deploy AWS EC2 instance with Security Group for Docker

provider "aws" {
  region = "eu-west-1" # Replace with your preferred AWS region
}

# Security Group for Docker
resource "aws_security_group" "docker_sg" {
  name        = "docker_sg"
  description = "Allow HTTP and SSH access"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Docker-SG"
  }
}

# EC2 Instance with proper AMI, Security Group, and SSH Key
resource "aws_instance" "docker_host" {
  ami                    = "ami-0c1bc246476a5572b"  # Amazon Linux 2 AMI ID
  instance_type          = "t2.micro"
  key_name               = "aws_key"   # Corrected to match your AWS SSH key pair exactly
  vpc_security_group_ids = [aws_security_group.docker_sg.id]

  tags = {
    Name = "Docker-Server"
  }
}

# Output EC2 Public IP
output "docker_host_public_ip" {
  value = aws_instance.docker_host.public_ip
}

# Ensure AWS credentials configured via AWS CLI
# Run 'aws configure' and set your AWS Access key and Secret Key properly before running Terraform.2