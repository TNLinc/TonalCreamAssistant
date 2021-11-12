module "container_db" {
  source                       = "../container_definition_generator"
  container_name               = "${var.app_name}-db"
  container_image              = "tnlinc/db"
  container_cpu                = var.db_cpu
  container_memory             = var.db_memory
  container_memory_reservation = var.db_memory
  port_mappings = [{
    containerPort = "5432"
    hostPort      = "5432"
    protocol      = "tcp"
  }]
  map_environment = {
    "POSTGRES_DB"       = var.db_name
    "POSTGRES_USER"     = var.db_user
    "POSTGRES_PASSWORD" = var.db_password # should be stored as a secret in real case
  }
}

resource "aws_ecs_task_definition" "db" {
  family                   = "${var.app_name}-db"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.db_cpu
  memory                   = var.db_memory
  container_definitions    = module.container_db.json_map_encoded_list
  tags                     = var.tags
}

resource "aws_ecs_service" "db" {
  name                   = "${var.app_name}-db"
  cluster                = aws_ecs_cluster.cluster.id
  enable_execute_command = false
  task_definition        = aws_ecs_task_definition.db.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  service_registries {
    registry_arn = aws_service_discovery_service.db.arn
  }

  network_configuration {
    subnets          = var.controller_subnet_ids
    security_groups  = [aws_security_group.allow_webtnlinc.id]
    assign_public_ip = true
  }
  # depends_on = [
  #       aws_lb_listener.db
  # ]
}
