resource "aws_ecs_cluster" "cluster" {
  name               = var.app_name
  capacity_providers = ["FARGATE"]
  tags               = var.tags
}

