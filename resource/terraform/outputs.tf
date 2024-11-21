output "knowledge_base_id" {
  value       = module.amazon_bedrock.knowledge_base_id
  description = "Knowledge base id used for generate email content lambda"
}

output "agent_id" {
  value       = module.amazon_bedrock.agent_id
  description = "Agent id used for generate email content lambda"
}

output "alias_id" {
  value       = module.amazon_bedrock.alias_id
  description = "Alias id used for generate email content lambda"
}

output "document_key" {
  value = module.s3.s3_document_key
  description = "S3 document key for saving faq"
}

output "notification" {
  value = " ------- After creation knowledge base, you must go to sync datasource from AWS Bedrock console -----"
  description = ""
}