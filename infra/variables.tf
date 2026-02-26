variable "vpc_cidr_block" {
  description = "Bloco CIDR da minha VPC"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "live-primeiroterraform"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

# # Networking
# variable "availability_zones" {
#   description = "AZs para as subnets"
#   type        = list(string)
#   default     = ["us-east-1a", "us-east-1b"]
# }

# variable "public_subnet_cidrs" {
#   description = "CIDRs das subnets públicas"
#   type        = list(string)
#   default     = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# variable "private_subnet_cidrs" {
#   description = "CIDRs das subnets privadas"
#   type        = list(string)
#   default     = ["10.0.10.0/24", "10.0.20.0/24"]
# }

# # ECS / Container
# variable "container_port" {
#   description = "Porta exposta pelo container"
#   type        = number
#   default     = 80
# }

# variable "task_cpu" {
#   description = "CPU units para a task"
#   type        = string
#   default     = "256"
# }

# variable "task_memory" {
#   description = "Memória em MiB para a task"
#   type        = string
#   default     = "512"
# }

# variable "desired_count" {
#   description = "Número desejado de tasks rodando"
#   type        = number
#   default     = 2
# }

# variable "min_capacity" {
#   description = "Mínimo de tasks no auto scaling"
#   type        = number
#   default     = 1
# }

# variable "max_capacity" {
#   description = "Máximo de tasks no auto scaling"
#   type        = number
#   default     = 4
# }