data "aws_ami" "main" {
  most_recent = true
  name_regex  = "amazon-eks-arm64-node-1.27-v*"

  owners = ["amazon"]
}

resource "aws_launch_template" "nodegroup_launch_template" {
  name_prefix            = var.eks_node_group_launch_template_name
  ebs_optimized          = "true"
  image_id               = data.aws_ami.main.image_id
  instance_type          = var.eks_node_group_instance_type
  key_name               = var.eks_node_group_ssh_key
  vpc_security_group_ids = var.eks_node_group_security_group_ids


  tag_specifications {
    resource_type = "instance"
    tags          = var.eks_node_group_tags
  }

  lifecycle {
    ignore_changes = [
      tag_specifications[0].tags["Owner"]
    ]
  }

  user_data = base64encode(templatefile(format("%s%s", path.module, "/templates/userdata.sh.tpl"),
    {
      cluster_auth_base64 = var.eks_node_group_auth_base64
      endpoint            = var.eks_node_group_eks_endpoint
      cluster_name        = var.eks_cluster_name
      region              = var.eks_region
    }
  ))
}
