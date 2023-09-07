output "launch_template_name" {
  description = "Name of the launch template"
  value       = aws_launch_template.nodegroup_launch_template.name
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.nodegroup_launch_template.latest_version
}

output "asg_name" {
  description = "Name of autscaling group"
  value       = aws_eks_node_group.nodegroup.resources[0].autoscaling_groups[0].name
}
