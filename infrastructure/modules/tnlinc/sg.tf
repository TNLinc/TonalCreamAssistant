resource "aws_security_group" "controller_security_group" {
  name        = "${var.app_name}-controller"
  description = "${var.app_name} controller security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.alb_security_group.id]
    from_port       = "8000"
    to_port         = "8000"
    description     = "Communication channel to ${var.app_name}"
  }
  ingress {
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.alb_security_group.id]
    from_port       = "8001"
    to_port         = "8001"
    description     = "Communication channel to ${var.app_name}"
  }

  ingress {
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.alb_security_group.id]
    from_port       = "8002"
    to_port         = "8002"
    description     = "Communication channel to ${var.app_name}"
  }

  ingress {
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.alb_security_group.id]
    from_port       = "5432"
    to_port         = "5432"
    description     = "Communication channel to ${var.app_name}"
  }

  ingress {
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.alb_security_group.id]
    from_port       = "80"
    to_port         = "80"
    description     = "Communication channel to ${var.app_name}"
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "alb_security_group" {
  name        = "${var.app_name}-alb"
  description = "${var.app_name} alb security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Public access"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS Public access"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "allow_webtnlinc" {
  name        = "${var.app_name}-web-traffic-tnlinc"
  description = "Allow Web traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}