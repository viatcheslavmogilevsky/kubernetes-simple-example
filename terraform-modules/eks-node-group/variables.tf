variable "eks_node_group_eks_cluster_name" {
  description = "The name of the eks cluster"
  type        = string
}

variable "eks_node_group_name" {
  description = "The name of the node group"
  type        = string
}

variable "eks_node_role_arn" {
  description = "Role ARN of the EKS nodes"
  type        = string
}

variable "eks_node_group_subnet_ids" {
  description = "Subnet IDs of the node groups"
  type        = list(string)
}

variable "eks_node_group_desired_size" {
  description = "Desired size of the eks node group"
  type        = number
}

variable "eks_node_group_max_size" {
  description = "Max size of the node group"
  type        = number
}

variable "eks_node_group_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group."
  default     = "ON_DEMAND"
  type        = string
}
variable "eks_node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
}

variable "eks_node_group_instance_type" {
  description = "Instance types of the node group (t3.medium, c5,xlarge etc.)"
  type        = string
}

variable "eks_node_group_disk_size" {
  description = "Disk size of the node groups"
  type        = number
  default     = 100
}

variable "eks_node_group_labels" {
  description = "Labels of the node group"
  type        = map(any)
}

variable "eks_node_group_ssh_key" {
  description = "SSH key for the nodes"
  type        = string
}

variable "eks_node_group_security_group_ids" {
  description = "Security groups for the node groups"
  type        = list(string)
}

variable "eks_node_group_launch_template_name" {
  description = "Launch template name"
  type        = string
}

variable "eks_node_group_tags" {
  description = "Tags for the node groups"
  type        = map(any)
}

variable "eks_node_group_auth_base64" {
  description = "Cluster ca in base64"
  type        = string
}

variable "eks_node_group_eks_endpoint" {
  description = "endpoint of the eks cluster"
  type        = string
}

variable "eks_cluster_name" {
  description = "The name of the eks cluster."
  type        = string
}

variable "eks_region" {
  description = "The region of the eks cluster."
  type        = string
}
