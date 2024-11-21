output "s3_bucket_arn" {
    value = aws_s3_bucket.s3_ai_powered_email_auto_replies.arn
    description = "bucket arn"
}

output "s3_bucket_id" {
    value = aws_s3_bucket.s3_ai_powered_email_auto_replies.id
    description = "bucket id"
}

output "s3_bucket_domain_name" {
    value = aws_s3_bucket.s3_ai_powered_email_auto_replies.bucket_domain_name
    description = "bucket domain name"
}

output "s3_document_key" {
    value = aws_s3_object.faq_document.key
    description = "documents key for knowledge base amazon bedrock"
}
