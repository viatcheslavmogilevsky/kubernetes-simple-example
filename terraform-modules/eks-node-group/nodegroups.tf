resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = var.eks_node_group_eks_cluster_name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.eks_node_group_subnet_ids
  labels          = var.eks_node_group_labels
  capacity_type   = var.eks_node_group_capacity_type


  scaling_config {
    desired_size = var.eks_node_group_desired_size
    max_size     = var.eks_node_group_max_size
    min_size     = var.eks_node_group_min_size
  }

  launch_template {
    name    = aws_launch_template.nodegroup_launch_template.name
    version = aws_launch_template.nodegroup_launch_template.latest_version
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

