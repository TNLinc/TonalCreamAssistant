module "container_admin" {
  source                       = "../container_definition_generator"
  container_name               = "${var.app_name}-admin"
  container_image              = "tnlinc/admin-panel"
  container_cpu                = var.admin_cpu
  container_memory             = var.admin_memory
  container_memory_reservation = var.admin_memory
  port_mappings = [{
    containerPort = "8000"
    hostPort      = "8000"
    protocol      = "tcp"
  }]
  map_environment = {
    "ADMIN_PANEL_SECRET_KEY"    = var.admin_secret_key # should be stored as a secret in real case
    "ADMIN_PANEL_DEBUG"         = var.admin_debug
    "ADMIN_PANEL_DB_URL"        = "postgres://${var.db_user}:${var.db_password}@db.tnlinc:5432/${var.db_name}"
    "ADMIN_PANEL_ALLOWED_HOSTS" = "*"
  }
}

resource "aws_ecs_task_definition" "admin" {
  family                   = "${var.app_name}-admin"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.admin_cpu
  memory                   = var.admin_memory
  container_definitions    = module.container_admin.json_map_encoded_list
  tags                     = var.tags
}

resource "aws_ecs_service" "admin" {
  name                   = "${var.app_name}-admin"
  cluster                = aws_ecs_cluster.cluster.id
  enable_execute_command = false
  task_definition        = aws_ecs_task_definition.admin.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  service_registries {
    registry_arn = aws_service_discovery_service.admin.arn
  }
  network_configuration {
    subnets          = var.controller_subnet_ids
    security_groups  = [aws_security_group.allow_webtnlinc.id]
    assign_public_ip = true
  }
  # depends_on = [
  #   aws_lb_listener.admin
  # ]
}
