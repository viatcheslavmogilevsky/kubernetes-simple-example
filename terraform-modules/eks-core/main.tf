resource "aws_eks_cluster" "main" {
  name = var.eks_cluster_name


  role_arn = var.eks_role_arn

  enabled_cluster_log_types = var.eks_enabled_log_types
  version                   = var.eks_cluster_version
  tags                      = var.eks_tags

  vpc_config {
    subnet_ids              = var.eks_subnet_ids
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.eks_public_access_cidrs
    security_group_ids      = var.eks_security_group_ids
  }
}


data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name      = aws_eks_cluster.main.id
  addon_name        = "vpc-cni"
  resolve_conflicts = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_openid_connect_provider.cluster,
  ]
}

resource "aws_eks_addon" "kubeproxy" {
  cluster_name      = aws_eks_cluster.main.id
  addon_name        = "kube-proxy"
  resolve_conflicts = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_openid_connect_provider.cluster,
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.main.id
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_openid_connect_provider.cluster,
  ]
}
