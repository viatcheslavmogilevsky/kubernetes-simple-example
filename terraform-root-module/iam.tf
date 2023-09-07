data "aws_iam_policy_document" "eks_cluster" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cluster_elb_service_role" {
  statement {
    sid    = "AllowElasticLoadBalancer"
    effect = "Allow"
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSubnets"
    ]
    resources = ["*"]
  }
}

module "eks-cluster-role" {
  source = "../terraform-modules/iam"

  role_name          = "EksCluster"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster.json
  custom_iam_policies = [{
    name            = "EksCluster-ELB"
    description     = ""
    policy_document = data.aws_iam_policy_document.cluster_elb_service_role.json
  }]

  managed_iam_policies = [
    format("arn:%s:iam::aws:policy/AmazonEKSClusterPolicy", data.aws_partition.current.partition),
    format("arn:%s:iam::aws:policy/AmazonEKSServicePolicy", data.aws_partition.current.partition),
  ]

  force_detach_policies = false

  tags = var.tags
}

data "aws_iam_policy_document" "eks_cluster_worker" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "eks_cni_policy" {

  statement {
    effect = "Allow"
    actions = [
      "ec2:AssignIpv6Addresses",
      "ec2:AssignPrivateIpAddresses",
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:*:network-interface/*"
    ]
  }
}

module "eks-cluster-worker" {
  source = "../terraform-modules/iam"

  role_name          = "EksClusterWorker"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_worker.json
  custom_iam_policies = [{
    name        = "EksClusterWorker-CNI_Policy"
    description = ""
  policy_document = data.aws_iam_policy_document.eks_cni_policy.json }]

  managed_iam_policies = [
    format("arn:%s:iam::aws:policy/AmazonEKSWorkerNodePolicy", data.aws_partition.current.partition),
    format("arn:%s:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", data.aws_partition.current.partition),
  ]

  tags = var.tags
}