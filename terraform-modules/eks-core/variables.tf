variable "eks_cluster_name" {
  description = "The name of the eks cluster."
  type        = string
}

variable "eks_cluster_version" {
  description = "Desired k8s version"
  type        = string
  default     = "1.27"
}

variable "eks_role_arn" {
  description = "ARN of the EKS role."
  type        = string
}

variable "eks_enabled_log_types" {
  description = "The enabled log types of the EKS cluster."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "eks_tags" {
  description = "Tags of the EKS Cluster."
  type        = map(any)
}

variable "eks_subnet_ids" {
  description = "Subnet IDS of the eks subnet."
  type        = list(string)
}

variable "eks_endpoint_private_access" {
  description = "Make the private endpoints in EKS available."
  type        = bool
  default     = false
}

variable "eks_endpoint_public_access" {
  description = "Make the public endpoints in EKS available."
  type        = bool
  default     = true
}

variable "eks_public_access_cidrs" {
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_security_group_ids" {
  description = "EKS Security Groups"
  type        = list(string)
  default     = null
}
