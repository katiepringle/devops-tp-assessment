provider "aws" {
  region = "eu-north-1"
}

resource "aws_ecs_cluster" "cluster" {
  name = "devops-assessment-cluster"
}

resource "aws_ecs_task_definition" "hello-task" {
  family                   = "hello-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:ecs:eu-north-1:303981612052:cluster/hello-cluster"
  cpu                      = "256"
  memory                   = "512"
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

resource "aws_ecs_service" "hello-service" {
  name            = "hello-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.hello-task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-0e6602d986429902b"]
    security_groups = ["sg-0f82ac7586c7e1ce4"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "hello"
    container_port   = 5000
  }
}

resource "aws_lb" "lb" {
  name               = "hello-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["<security-group-id>"]
  subnets            = ["<subnet-1>", "<subnet-2>"]

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
