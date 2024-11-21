variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}

variable "aws_profile_name" {
  type        = string
  description = "AWS profile for using credentials"
  default     = "default"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for storing email"
}

variable "custom_domain" {
  description = "Your custom domain"
  type        = string
}

variable "sender_email" {
  description = "Your email you want to test"
  type        = string
}

variable "source_email" {
  description = "Source email for sending response"
  type = string
}
