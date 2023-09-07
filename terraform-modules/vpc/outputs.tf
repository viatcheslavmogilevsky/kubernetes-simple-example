output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "public_route_table_id_az_mapping" {
  description = "The AZ-to-id mapping of route tables associated with public subnets"
  value       = { for az, index in local.public_azs : "${az}" => aws_route_table.public[az].id }
}

output "private_route_table_id_az_mapping" {
  description = "The AZ-to-id mapping of route tables associated with public subnets"
  value       = { for az, index in local.private_azs : "${az}" => aws_route_table.private[az].id }
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.vpc.main_route_table_id
}

output "default_route_table_id" {
  description = "The ID of the default route table in the VPC"
  value       = aws_vpc.vpc.default_route_table_id
}

output "public_subnet_az_mapping" {
  description = "The AZ-to-id mapping of public subnets"
  value       = { for az, index in local.public_azs : "${az}" => aws_subnet.public[az].id }
}

output "private_subnet_az_mapping" {
  description = "The AZ-to-id mapping of private subnets"
  value       = { for az, index in local.private_azs : "${az}" => aws_subnet.private[az].id }
}
