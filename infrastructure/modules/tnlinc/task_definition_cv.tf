module "container_cv" {
  source                       = "../container_definition_generator"
  container_name               = "${var.app_name}-cv"
  container_image              = "tnlinc/cv"
  container_cpu                = var.cv_cpu
  container_memory             = var.cv_memory
  container_memory_reservation = var.cv_memory
  port_mappings = [{
    containerPort = "8000"
    hostPort      = "8000"
    protocol      = "tcp"
  }]
  map_environment = {
    "CV_SECRET_KEY"    = var.cv_secret_key # should be stored as a secret in real case
    "CV_DEBUG"         = var.cv_debug
    "CV_ALLOWED_HOSTS" = "*"
  }
}

resource "aws_ecs_task_definition" "cv" {
  family                   = "${var.app_name}-cv"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cv_cpu
  memory                   = var.cv_memory
  container_definitions    = module.container_cv.json_map_encoded_list
  tags                     = var.tags
}

resource "aws_ecs_service" "cv" {
  name                   = "${var.app_name}-cv"
  cluster                = aws_ecs_cluster.cluster.id
  enable_execute_command = false
  task_definition        = aws_ecs_task_definition.cv.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  service_registries {
    registry_arn = aws_service_discovery_service.cv.arn
  }

  network_configuration {
    subnets          = var.controller_subnet_ids
    security_groups  = [aws_security_group.allow_webtnlinc.id]
    assign_public_ip = true
  }
  #   depends_on = [
  #     aws_lb_listener.cv
  #   ]
}
