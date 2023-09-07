

variable "role_name" {
  description = "The name of the IAM Role"
  type        = string
}

variable "assume_role_policy" {
  description = "The assume role policy for the IAM role"
  type        = string
  default     = "dummy"
}

variable "path" {
  type        = string
  description = "The path to the role"
  default     = "/"
}

variable "custom_iam_policies" {
  description = "The custom IAM policies to be attached with the IAM"
  type = list(object({
    name            = string
    description     = string
    policy_document = string
  }))
  default = []
}

variable "managed_iam_policies" {
  description = "The list of managed polices that needs to be attached to the IAM Role"
  type        = list(string)
  default     = []
}

variable "force_detach_policies" {
  description = "Force detach policies when deleting the IAM Role"
  type        = bool
  default     = true
}

variable "description" {
  description = "The description of the IAM role"
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "The maximum session duration for the role"
  type        = number
  default     = 3600
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
}

