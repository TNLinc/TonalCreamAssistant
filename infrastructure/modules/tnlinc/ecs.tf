resource "aws_ecs_cluster" "cluster" {
  name               = var.app_name
  capacity_providers = ["FARGATE"]
  tags               = var.tags
}

resource "aws_ecs_service" "controller" {
  name                   = "${var.app_name}-controller"
  cluster                = aws_ecs_cluster.cluster.id
  enable_execute_command = true
  task_definition        = aws_ecs_task_definition.controller.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "" #front container
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.controller_subnet_ids
    security_groups  = [aws_security_group.controller_security_group.id]
    assign_public_ip = false
  }
  depends_on = [
    aws_lb.loadbalancer
  ]
}