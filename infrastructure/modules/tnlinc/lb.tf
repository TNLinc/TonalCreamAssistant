# resource "aws_lb" "loadbalancer" {
#   name               = "${var.app_name}-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_security_group.id]
#   subnets            = var.alb_subnet_ids
#   tags               = var.tags
# }

# resource "aws_lb_target_group" "lb_db_target_group" {
#   name        = "${var.app_name}-db-target-froup"
#   port        = "5432"
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     enabled = true
#     path = "/test"
#   }
#   tags = var.tags
#   depends_on = [
#     aws_lb.loadbalancer
#   ]
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_lb_listener" "db" {
#   load_balancer_arn = aws_lb.loadbalancer.arn
#   port              = 79
#   protocol          = "HTTP"

#   default_action {
#     type             = "redirect"
#     target_group_arn = aws_lb_target_group.lb_db_target_group.arn
#     redirect {
#       protocol    = "HTTP"
#       path        = 5432
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_target_group" "lb_admin_target_group" {
#   name        = "${var.app_name}-admin-target-froup"
#   port        = "8000"
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     enabled = true
#     port = 8000
#   }
#   tags = var.tags
#   depends_on = [
#     aws_lb.loadbalancer
#   ]
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_lb_listener" "admin" {
#   load_balancer_arn = aws_lb.loadbalancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "redirect"
#     target_group_arn = aws_lb_target_group.lb_admin_target_group.arn
#     redirect {
#       protocol    = "HTTP"
#       path        = "/admin"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_target_group" "lb_vendor_target_group" {
#   name        = "${var.app_name}-vendor-target-froup"
#   port        = "8001"
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     enabled = true
#     port = 8000
#   }
#   tags = var.tags
#   depends_on = [
#     aws_lb.loadbalancer
#   ]
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_lb_listener" "vendor" {
#   load_balancer_arn = aws_lb.loadbalancer.arn
#   port              = 81
#   protocol          = "HTTP"

#   default_action {
#     type             = "redirect"
#     target_group_arn = aws_lb_target_group.lb_vendor_target_group.arn
#     redirect {
#       protocol    = "HTTP"
#       port        = 8001
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_target_group" "lb_cv_target_group" {
#   name        = "${var.app_name}-cv-target-froup"
#   port        = "8002"
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     enabled = true
#     port = 8002
#   }
#   tags = var.tags
#   depends_on = [
#     aws_lb.loadbalancer
#   ]
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_lb_listener" "cv" {
#   load_balancer_arn = aws_lb.loadbalancer.arn
#   port              = 82
#   protocol          = "HTTP"


#   default_action {
#     type             = "redirect"
#     target_group_arn = aws_lb_target_group.lb_cv_target_group.arn
#     redirect {
#       protocol    = "HTTP"
#       path        = "/api/cv"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "cv_spec" {
#   load_balancer_arn = aws_lb.loadbalancer.arn
#   port              = 83
#   protocol          = "HTTP"


#   default_action {
#     type             = "redirect"
#     target_group_arn = aws_lb_target_group.lb_cv_target_group.arn
#     redirect {
#       protocol    = "HTTP"
#       path        = "/flask-apispec"
#       status_code = "HTTP_301"
#     }
#   }
# }