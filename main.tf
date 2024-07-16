provider "aws" {
  version = "~> 2.0"
  region = "eu-north-1"
}

terraform {
  required_version = "~> 0.12.0"
}

resource "aws_ecs_cluster" "cluster" {
  name = "hello-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "hello-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:ecs:eu-north-1:303981612052:task-definition/hello-task:1"
  cpu                      = "1024"
  memory                   = "3072"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "hello",
      "image": "303981612052.dkr.ecr.eu-north-1.amazonaws.com/hello-repo:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "service" {
  name            = "hello-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.hello-task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-0e6602d986429902b, subnet-01ede7aa401079856"]
    security_groups = ["sg-0f82ac7586c7e1ce4"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "hello"
    container_port   = 5000
  }
}

# Define VPC
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "hello-vpc"
   User = "katpri"
 }
}


# Define Subnets
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
}

# Define Security Group
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Application Load Balancer
resource "aws_lb" "lb" {
  name               = "hello-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  name     = "hello-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = "vpc-00055bb8a497cb397"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
