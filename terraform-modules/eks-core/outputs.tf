output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS Cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca" {
  description = "The CA of the EKS Cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "oidc_issuer" {
  description = "The OIDC issuer for the cluster"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_security_group_id" {
  description = "The ID security group of the EKS Cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}


