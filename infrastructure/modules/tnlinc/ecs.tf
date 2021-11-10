resource "aws_ecs_cluster" "cluster" {
  name               = var.app_name
  capacity_providers = ["FARGATE"]
  tags               = var.tags
}

resource "aws_service_discovery_private_dns_namespace" "discovery" {
  name        = var.app_name
  vpc         = var.vpc_id
  description = "${var.app_name} discovery managed zone"
}

resource "aws_service_discovery_service" "db" {
  name = "db"
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.discovery.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 60
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "nginx" {
  name = "nginx"
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.discovery.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 60
      type = "A"
    }
    dns_records {
      ttl  = 60
      type = "SRV"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "admin" {
  name = "admin"
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.discovery.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 60
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "vendor" {
  name = "vendor"
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.discovery.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 60
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "cv" {
  name = "cv"
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.discovery.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 60
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}
