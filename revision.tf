provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAVN4ZX4MVAQRNHUI3"
  secret_key = "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"
}

#1 EC2 Instance 

resource "aws_instance" "DataSource-Server" {
  ami           = "ami-0dc2d3e4c0f9ebd18"
  instance_type = "t2.micro"
   
}

#2 IAM Web USER
resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"
  count = 5

}

#3 EIP

resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  vpc      = true
}

#4 Security Group

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}