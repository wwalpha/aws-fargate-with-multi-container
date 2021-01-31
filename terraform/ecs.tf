# ----------------------------------------------------------------------------------------------
# ECR - Nginx
# ----------------------------------------------------------------------------------------------
resource "aws_ecr_repository" "nginx" {
  name                 = "onecloud-multi-container-nginx"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# ----------------------------------------------------------------------------------------------
# ECR - Backend
# ----------------------------------------------------------------------------------------------
resource "aws_ecr_repository" "backend" {
  name                 = "onecloud-multi-container-backend"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# ----------------------------------------------------------------------------------------------
# ECS Cluster
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_cluster" "fargate" {
  name = "onecloud-multi-container"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ----------------------------------------------------------------------------------------------
# ECS Task Definition - Multi Container
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "multi_container" {
  depends_on            = [aws_ecr_repository.nginx, aws_ecr_repository.backend]
  family                = "onecloud-multi-container"
  container_definitions = file("taskdef/multi_container.json")
  task_role_arn         = aws_iam_role.ecs_task_exec.arn
  execution_role_arn    = aws_iam_role.ecs_task_exec.arn
  network_mode          = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu    = "512"
  memory = "1024"
}

# ----------------------------------------------------------------------------------------------
# ECS Service - Multi Container
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_service" "multi_container" {
  name                               = "multi_container"
  cluster                            = aws_ecs_cluster.fargate.id
  desired_count                      = 1
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  task_definition                    = aws_ecs_task_definition.multi_container.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    assign_public_ip = false
    subnets          = var.private_subnet_ids
    security_groups  = var.vpc_security_groups
  }
  scheduling_strategy = "REPLICA"

  load_balancer {
    target_group_arn = aws_lb_target_group.multi_container.arn
    container_name   = "onecloud-multi-container-nginx"
    container_port   = 80
  }
}
