variable "bucket_arn" {
  type = string
  description = "Bucket ARN for saving the document"
}

variable "document_key" {
  type = string
  default = "documents/faqs.txt"
  description = "Document key for knowledge base datasource"
}

variable "iam_role_kb_arn" {
  type = string
  description = "IAM Role for Amazon Bedrock"
}

variable "iam_role_agent_arn" {
  type = string
  description = "IAM Role for Amazon Bedrock Agent"
}
