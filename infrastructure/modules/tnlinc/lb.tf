resource "aws_lb" "loadbalancer" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = var.alb_subnet_ids
  tags               = var.tags
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "${var.app_name}-target-froup"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled = false
  }
  tags = var.tags
  depends_on = [
    aws_lb.loadbalancer
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}
