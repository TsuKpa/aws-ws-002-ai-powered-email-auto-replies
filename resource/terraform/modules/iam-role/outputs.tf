output "iam_extract_email_role_arn" {
  description = "IAM Role extract email function arn"
  value       = aws_iam_role.iam_extract_email_role.arn
}
output "iam_generate_email_role_arn" {
  description = "IAM Role for generate email function arn"
  value       = aws_iam_role.iam_generate_email_role.arn
}
output "iam_send_email_role_arn" {
  description = "IAM Role for send email function arn"
  value       = aws_iam_role.iam_send_email_role.arn
}

output "iam_role_ses_s3_arn" {
  description = "IAM Role for send email function arn"
  value       = aws_iam_role.ses_s3.arn
}

output "iam_role_amazon_bedrock_kb_arn" {
  value       = aws_iam_role.iam_role_bedrock_knowledge_base.arn
  description = "IAM Role for Amazon Bedrock Knowledge Base ARN"
}

output "iam_role_amazon_bedrock_agent_arn" {
  value       = aws_iam_role.iam_role_bedrock_agent.arn
  description = "IAM Role for Amazon Bedrock Agent ARN"
}
