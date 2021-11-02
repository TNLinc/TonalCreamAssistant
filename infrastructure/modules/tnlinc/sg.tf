resource "aws_security_group" "controller_security_group" {
  name        = "${var.app_name}-controller"
  description = "${var.app_name} controller security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.alb_security_group.id, aws_security_group.ssh-sg.id, aws_security_group.access-sg.id]
    from_port       = var.container_port
    to_port         = var.container_port
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