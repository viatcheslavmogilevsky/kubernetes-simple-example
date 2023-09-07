variable "region" {
  description = "The AWS region where all terraform operations are carried out."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}
