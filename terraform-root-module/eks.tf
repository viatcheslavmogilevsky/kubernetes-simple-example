module "eks-cluster" {
  source = "../terraform-modules/eks-core"

  eks_cluster_name       = "test"
  eks_role_arn           = module.eks-cluster-role.iam_role_arn
  eks_tags               = var.tags
  eks_subnet_ids         = concat(values(module.compute.public_subnet_az_mapping), values(module.compute.private_subnet_az_mapping))
  eks_security_group_ids = []
}


module "eks-cluster-nodes" {
  source = "../terraform-modules/eks-node-group"

  eks_node_role_arn               = module.eks-cluster-worker.iam_role_arn
  eks_node_group_eks_cluster_name = module.eks-cluster.cluster_id

  eks_node_group_name = "main"


  eks_node_group_desired_size = 2
  eks_node_group_max_size     = 3
  eks_node_group_min_size     = 2

  eks_node_group_subnet_ids    = values(module.compute.private_subnet_az_mapping)
  eks_node_group_capacity_type = "SPOT"
  eks_node_group_labels        = {}


  eks_node_group_launch_template_name = "main"
  eks_node_group_instance_type        = "t4g.medium"
  eks_node_group_ssh_key              = null

  eks_node_group_tags = {
    Name = "${module.eks-cluster.cluster_id}-worker"
  }

  eks_node_group_security_group_ids = [
    module.eks-cluster.cluster_security_group_id,
  ]


  eks_node_group_auth_base64  = module.eks-cluster.cluster_ca
  eks_cluster_name            = module.eks-cluster.cluster_id
  eks_node_group_eks_endpoint = module.eks-cluster.cluster_endpoint
  eks_region                  = data.aws_region.current.name
}
