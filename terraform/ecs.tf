resource "aws_ecs_cluster" "main" {
  name = "url-shortener"
}

resource "aws_ecs_task_definition" "url_app" {
  family                   = "url-shortener"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions = jsonencode([
    {
      name         = "url-shortener"
      image        = var.container_image
      essential    = true
      environment  = [{ name = "TABLE_NAME", value = var.ddb_table_name }]
      portMappings = [{ containerPort = 8080, hostPort = 8080 }]
    }
  ])
}

resource "aws_ecs_service" "url_app" {
  name            = "url-shortener-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.url_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.VPC.private_subnets
    security_groups  = [aws_security_group.ecs_task_eni.id]
    assign_public_ip = false
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task_ddb" {
  name = "ecsTaskDynamoDBPolicy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
      ]
      Resource = "arn:aws:dynamodb:eu-west-2:${var.aws_account_id}:table/test-table"
    }
  })
}

resource "aws_security_group" "ecs_task_eni" {
  name        = "ecs-task-eni"
  vpc_id      = module.VPC.vpc_id
  description = "SG for ECS service tasks ENI"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = LB SG here
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
