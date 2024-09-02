
# AWS connection & authentication

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
  default     = "AKIAXZEFI********"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
  default     = "Dd0K******"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-north-1"
}
