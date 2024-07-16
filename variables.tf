variable "region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "List of subnets for the ECS tasks"
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "hello-cluster"
}

variable "task_execution_role_arn" {
  description = "The ARN of the IAM role that allows ECS to make calls to your load balancer"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = "hello-container"
}

variable "container_port" {
  description = "The port the container is listening on"
  type        = number
  default     = 80
}

variable "task_memory" {
  description = "The amount of memory (in MiB) used by the task"
  type        = string
  default     = "512"
}

variable "task_cpu" {
  description = "The number of CPU units used by the task"
  type        = string
  default     = "256"
}

variable "docker_image" {
  description = "The Docker image for the container"
  type        = string
}

variable "desired_count" {
  description = "The desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = "/ecs/devops-assessment"
}

variable "lb_arn" {
  description = "The ARN of the load balancer"
  type        = string
}

variable "lb_target_group_arn" {
  description = "The ARN of the load balancer target group"
  type        = string
}
