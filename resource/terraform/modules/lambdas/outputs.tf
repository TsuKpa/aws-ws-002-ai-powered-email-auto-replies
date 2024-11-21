output "generate_function_arn" {
    description = "ARN for trigger event SES"
    value = aws_lambda_function.extract_email_content.arn
}
