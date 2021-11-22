module "container_vendor" {
  source                       = "../container_definition_generator"
  container_name               = "${var.app_name}-vendor"
  container_image              = "tnlinc/vendor"
  container_cpu                = var.vendor_cpu
  container_memory             = var.vendor_memory
  container_memory_reservation = var.vendor_memory
  port_mappings = [{
    containerPort = "8000"
    hostPort      = "8000"
    protocol      = "tcp"
  }]
  map_environment = {
    "VENDOR_DB_URL"         = "postgresql+asyncpg://${var.db_user}:${var.db_password}@db.tnlinc:5432/${var.db_name}"
    "VENDOR_DB_AUTH_SCHEMA" = var.vendor_db_auth
    "VENDOR_ALLOWED_HOSTS"  = "*"
  }
}

resource "aws_ecs_task_definition" "vendor" {
  family                   = "${var.app_name}-vendor"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.vendor_cpu
  memory                   = var.vendor_memory
  container_definitions    = module.container_vendor.json_map_encoded_list
  tags                     = var.tags
}

resource "aws_ecs_service" "vendor" {
  name                   = "${var.app_name}-vendor"
  cluster                = aws_ecs_cluster.cluster.id
  enable_execute_command = false
  task_definition        = aws_ecs_task_definition.vendor.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  service_registries {
    registry_arn = aws_service_discovery_service.vendor.arn
  }

  network_configuration {
    subnets          = var.controller_subnet_ids
    security_groups  = [aws_security_group.allow_webtnlinc.id]
    assign_public_ip = true
  }
  #   depends_on = [
  #     aws_lb_listener.db
  #   ]
}
