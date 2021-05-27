provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

resource "aws_security_group" "ubuntu" {

  name        = "ton-challenge-security-group"
  description = "Allow HTTPS, HTTP, SSH"

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ton-challenge"
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-03ba3948f6c37a4b0"
  instance_type = "t2.micro"
  monitoring    = true
  user_data     = <<EOF
                  #!/bin/bash
                  sudo su
                  apt-get install apache2 -y
                  echo "<p> Estou executando na AWS </p>" >> /var/www/html/index.html
                  sudo chkconfig apache2 on
                  sudo service start httpd
                EOF

  tags = {
    Name = "ton-ubuntu-server"
  }

  vpc_security_group_ids = [
    aws_security_group.ubuntu.id
  ]

}

resource "aws_eip" "ubuntu" {
  vpc      = true
  instance = aws_instance.ubuntu.id

}

output "DNS" {
  value = aws_eip.ubuntu.public_dns
}


