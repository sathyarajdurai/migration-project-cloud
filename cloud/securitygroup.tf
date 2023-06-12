resource "aws_security_group" "lb_internet_face" {
  name        = "allow-https"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

  }

  egress {
    description      = "default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "load-balancer-sg"
  }
}


resource "aws_security_group" "web_server_sg" {
  name        = "web-server"
  description = "Allow alb inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    # cidr_blocks = ["0.0.0.0/0"]
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_internet_face.id]

  }

  ingress {
    # cidr_blocks = ["0.0.0.0/0"]
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_internet_face.id]
  }

  # ingress {
  #   cidr_blocks = [jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string).myaddress1]
  #   description = "ssh from VPC"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"

  # }

  egress {
    description      = "default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}