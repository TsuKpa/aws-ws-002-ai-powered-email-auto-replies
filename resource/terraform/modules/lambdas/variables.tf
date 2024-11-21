
################################################################################
# IAM Role ARN
################################################################################

variable "iam_extract_email_role_arn" {
    description = "IAM Role extract email function arn"
    type = string
}

variable "iam_generate_email_role_arn" {
    description = "IAM Role for generate email function arn"
    type = string
}

variable "iam_send_email_role_arn" {
    description = "IAM Role for send email function arn"
    type = string
}

################################################################################
# Cloudwatch loggroup names
################################################################################

variable "lambda_log_groups_extract_name" {
    description = "Cloudwatch loggroup name extract email function"
    type = string
}

variable "lambda_log_groups_generate_name" {
    description = "Cloudwatch loggroup name generate email function"
    type = string
}

variable "lambda_log_groups_send_name" {
    description = "Cloudwatch loggroup name send email function"
    type = string
}

################################################################################
# Queue Name
################################################################################

variable "generate_sqs_name" {
  description = "Generate Queue Name to generate email content by Amazon bedrock"
  type = string
}

variable "generate_sqs_arn" {
  description = "Generate Queue ARN to trigger Lambda function"
  type = string
}

variable "send_response_sqs_name" {
  description = "Send Response Queue Name to reply email"
  type = string
}

variable "send_response_sqs_arn" {
  description = "Send Response Queue ARN to reply email"
  type = string
}

variable "bucket_name" {
  description = "Bucket Name to get email content"
  type = string
}

################################################################################
# Variables
################################################################################

variable "customer_service_agent_id" {
  description = "Customer service agent id for generating email content"
  type = string
}

variable "customer_service_agent_alias_id" {
  description = "Customer service agent alias id for generating email content"
  type = string
}

variable "knowledge_base_id" {
  description = "Customer service knowledge base id for generating email content"
  type = string
}

variable "source_email" {
  description = "Source email for sending response"
  type = string
}
