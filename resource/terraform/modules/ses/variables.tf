variable "custom_domain" {
  description = "Your custom domain"
  type = string
}

variable "sender_email" {
  description = "Your email you want to test"
  type = string
}

variable "bucket_name" {
  description = "Your bucket name you want to store receiving email"
  type = string
}

variable "generate_function_arn" {
  description = "The ARN of generate lambda function"
  type = string
}

variable "iam_role_ses_s3_arn" {
    description = "IAM Role for send email function arn"
    type = string
}
