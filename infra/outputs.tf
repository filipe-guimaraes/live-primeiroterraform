# # VPC
# output "vpc_id" {
#   description = "ID da VPC"
#   value       = aws_vpc.this.id
# }

# # Subnets
# output "public_subnet_ids" {
#   description = "IDs das subnets públicas"
#   value       = aws_subnet.public[*].id
# }

# output "private_subnet_ids" {
#   description = "IDs das subnets privadas"
#   value       = aws_subnet.private[*].id
# }

# # ALB
# output "alb_dns_name" {
#   description = "DNS name do ALB - use para acessar a aplicação"
#   value       = aws_lb.this.dns_name
# }

# # ECR
# output "ecr_repository_url" {
#   description = "URL do repositório ECR"
#   value       = aws_ecr_repository.this.repository_url
# }

# # ECS
# output "ecs_cluster_name" {
#   description = "Nome do cluster ECS"
#   value       = aws_ecs_cluster.this.name
# }

# output "ecs_service_name" {
#   description = "Nome do serviço ECS"
#   value       = aws_ecs_service.this.name
# }
