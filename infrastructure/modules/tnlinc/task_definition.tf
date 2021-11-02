module "container_controller" {
  source                       = "../container_definition_generator"
  container_name               = "${var.app_name}-controller"
  container_image              = "" #docker image here
  container_cpu                = var.controller_cpu
  container_memory             = var.controller_memory
  container_memory_reservation = var.controller_memory
  port_mappings = [{
    containerPort = var.continer_port
    hostPort      = var.continer_port
    protocol      = "tcp"
  }]
  map_environment = {
    #key-value pairs here
  }
}

resource "aws_ecs_task_definition" "controller" {
  family                   = var.app_name
  task_role_arn            = aws_iam_role.jenkins_controller_task_role.arn
  execution_role_arn       = aws_iam_role.jenkins_controller_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.controller_cpu
  memory                   = var.controller_memory
  container_definitions    = module.container_controller.json_map_encoded_list
  tags                     = var.tags
}
