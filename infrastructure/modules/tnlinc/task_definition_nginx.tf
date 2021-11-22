module "container_nginx" {
  source                       = "../container_definition_generator"
  container_name               = "${var.app_name}-nginx"
  container_image              = "tnlinc/nginx"
  container_cpu                = var.db_cpu
  container_memory             = var.db_memory
  container_memory_reservation = var.db_memory
  port_mappings = [{
    containerPort = "80"
    hostPort      = "80"
    protocol      = "tcp"
  }]
}

resource "aws_ecs_task_definition" "nginx" {
  family                   = "${var.app_name}-nginx"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.db_cpu
  memory                   = var.db_memory
  container_definitions    = module.container_nginx.json_map_encoded_list
  tags                     = var.tags
}

resource "aws_ecs_service" "nginx" {
  name                   = "${var.app_name}-nginx"
  cluster                = aws_ecs_cluster.cluster.id
  enable_execute_command = false

  task_definition  = aws_ecs_task_definition.nginx.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  service_registries {
    registry_arn = aws_service_discovery_service.nginx.arn
    port         = 80
  }
  network_configuration {
    subnets          = var.controller_subnet_ids
    security_groups  = [aws_security_group.allow_webtnlinc.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_port   = "80"
    container_name   = "${var.app_name}-nginx"
  }
  depends_on = [
    aws_lb_listener.http
  ]
}
