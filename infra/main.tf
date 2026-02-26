resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# # Subnets Públicas (us-east-1a e us-east-1b)
# resource "aws_subnet" "public" {
#   count = length(var.public_subnet_cidrs)

#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = var.public_subnet_cidrs[count.index]
#   availability_zone       = var.availability_zones[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${var.project_name}-public-${var.availability_zones[count.index]}"
#   }
# }

# # Subnets Privadas (us-east-1a e us-east-1b)
# resource "aws_subnet" "private" {
#   count = length(var.private_subnet_cidrs)

#   vpc_id            = aws_vpc.this.id
#   cidr_block        = var.private_subnet_cidrs[count.index]
#   availability_zone = var.availability_zones[count.index]

#   tags = {
#     Name = "${var.project_name}-private-${var.availability_zones[count.index]}"
#   }
# }

# # NAT Gateway (Elastic IP + NAT)
# resource "aws_eip" "nat" {
#   domain = "vpc"

#   tags = {
#     Name = "${var.project_name}-nat-eip"
#   }
# }

# resource "aws_nat_gateway" "this" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id

#   tags = {
#     Name = "${var.project_name}-nat"
#   }

#   depends_on = [aws_internet_gateway.this]
# }

# # Route Tables

# # Pública -> Internet Gateway
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.this.id
#   }

#   tags = {
#     Name = "${var.project_name}-public-rt"
#   }
# }

# resource "aws_route_table_association" "public" {
#   count = length(aws_subnet.public)

#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# # Privada -> NAT Gateway
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.this.id
#   }

#   tags = {
#     Name = "${var.project_name}-private-rt"
#   }
# }

# resource "aws_route_table_association" "private" {
#   count = length(aws_subnet.private)

#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

# # Security Group - ALB
# resource "aws_security_group" "alb" {
#   name        = "${var.project_name}-alb-sg"
#   description = "Security group do ALB - permite trafego HTTP"
#   vpc_id      = aws_vpc.this.id

#   tags = {
#     Name = "${var.project_name}-alb-sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "alb_http" {
#   security_group_id = aws_security_group.alb.id
#   description       = "HTTP da internet"
#   from_port         = 80
#   to_port           = 80
#   ip_protocol       = "tcp"
#   cidr_ipv4         = "0.0.0.0/0"
# }

# resource "aws_vpc_security_group_egress_rule" "alb_all" {
#   security_group_id = aws_security_group.alb.id
#   description       = "Saida para qualquer destino"
#   ip_protocol       = "-1"
#   cidr_ipv4         = "0.0.0.0/0"
# }

# # Security Group - ECS Tasks
# resource "aws_security_group" "ecs_tasks" {
#   name        = "${var.project_name}-ecs-tasks-sg"
#   description = "Security group das tasks ECS - permite trafego vindo do ALB"
#   vpc_id      = aws_vpc.this.id

#   tags = {
#     Name = "${var.project_name}-ecs-tasks-sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
#   security_group_id            = aws_security_group.ecs_tasks.id
#   description                  = "Trafego vindo do ALB"
#   from_port                    = var.container_port
#   to_port                      = var.container_port
#   ip_protocol                  = "tcp"
#   referenced_security_group_id = aws_security_group.alb.id
# }

# resource "aws_vpc_security_group_egress_rule" "ecs_all" {
#   security_group_id = aws_security_group.ecs_tasks.id
#   description       = "Saida para qualquer destino (pull de imagens, etc)"
#   ip_protocol       = "-1"
#   cidr_ipv4         = "0.0.0.0/0"
# }

# # Application Load Balancer
# resource "aws_lb" "this" {
#   name               = "${var.project_name}-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]
#   subnets            = aws_subnet.public[*].id

#   tags = {
#     Name = "${var.project_name}-alb"
#   }
# }

# # Target Group
# resource "aws_lb_target_group" "this" {
#   name        = "${var.project_name}-tg"
#   port        = var.container_port
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.this.id
#   target_type = "ip"

#   health_check {
#     enabled             = true
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     timeout             = 5
#     interval            = 30
#     path                = "/"
#     protocol            = "HTTP"
#     matcher             = "200"
#   }

#   tags = {
#     Name = "${var.project_name}-tg"
#   }
# }

# # Listener HTTP :80
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }

# # ECR - Elastic Container Registry
# resource "aws_ecr_repository" "this" {
#   name                 = var.project_name
#   image_tag_mutability = "MUTABLE"
#   force_delete         = true

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = {
#     Name = "${var.project_name}-ecr"
#   }
# }

# # IAM Role - ECS Task Execution
# data "aws_iam_policy_document" "ecs_assume_role" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "ecs_task_execution" {
#   name               = "${var.project_name}-ecs-task-execution"
#   assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

#   tags = {
#     Name = "${var.project_name}-ecs-task-execution"
#   }
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
#   role       = aws_iam_role.ecs_task_execution.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# # CloudWatch Log Group
# resource "aws_cloudwatch_log_group" "ecs" {
#   name              = "/ecs/${var.project_name}"
#   retention_in_days = 7

#   tags = {
#     Name = "${var.project_name}-logs"
#   }
# }

# # ECS Cluster
# resource "aws_ecs_cluster" "this" {
#   name = "${var.project_name}-cluster"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }

#   tags = {
#     Name = "${var.project_name}-cluster"
#   }
# }

# # ECS Task Definition
# resource "aws_ecs_task_definition" "this" {
#   family                   = "${var.project_name}-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = var.task_cpu
#   memory                   = var.task_memory
#   execution_role_arn       = aws_iam_role.ecs_task_execution.arn

#   container_definitions = jsonencode([
#     {
#       name      = var.project_name
#       image     = "nginx:latest"
#       essential = true

#       portMappings = [
#         {
#           containerPort = var.container_port
#           hostPort      = var.container_port
#           protocol      = "tcp"
#         }
#       ]

#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
#           "awslogs-region"        = "us-east-1"
#           "awslogs-stream-prefix" = "ecs"
#         }
#       }
#     }
#   ])

#   tags = {
#     Name = "${var.project_name}-task"
#   }
# }

# # ECS Service
# resource "aws_ecs_service" "this" {
#   name            = "${var.project_name}-service"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.this.arn
#   desired_count   = var.desired_count
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets          = aws_subnet.private[*].id
#     security_groups  = [aws_security_group.ecs_tasks.id]
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.this.arn
#     container_name   = var.project_name
#     container_port   = var.container_port
#   }

#   depends_on = [aws_lb_listener.http]

#   tags = {
#     Name = "${var.project_name}-service"
#   }
# }

# resource "aws_appautoscaling_target" "ecs" {
#   max_capacity       = var.max_capacity
#   min_capacity       = var.min_capacity
#   resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_cpu" {
#   name               = "${var.project_name}-cpu-autoscaling"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     target_value = 70
#   }
# }