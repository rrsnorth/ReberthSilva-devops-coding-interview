variable "aws_region" { type = string }
variable "name" { type = string }
variable "cluster_name" { type = string }

variable "ecr_repository_url" { type = string }
variable "image_tag" { type = string }

variable "cpu" { type = number, default = 256 }
variable "memory" { type = number, default = 512 }
variable "desired_count" { type = number, default = 2 }

variable "container_port" { type = number, default = 8000 }
variable "health_path" { type = string, default = "/health" }

variable "environment" { type = map(string), default = {} }

variable "log_retention_days" { type = number, default = 14 }

# Networking + LB integration
variable "private_subnet_ids" { type = list(string) }
variable "service_security_group_ids" { type = list(string) }
variable "target_group_arn" { type = string }

# Optional: if you want app to call AWS APIs
variable "task_role_arn" { type = string, default = null }
