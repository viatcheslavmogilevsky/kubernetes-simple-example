variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "azs" {
  description = "A list of Availability zones in the region"
  type        = list(string)
}

variable "enable_public_subnets" {
  description = "should be true if you want to use public subnets within VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "should be true if you want to provision NAT Gateway(s) within the VPC"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "should be true if you want to provision only single NAT Gateway instead on per public subnet (useful in non-prod environments)"
  type        = bool
  default     = true
}

variable "enable_internet_gateway" {
  description = "should be true if you want to provision internet gateway in VPC"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable/Disable IPV6 support"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  type        = bool
  default     = true
}
