output "lambda_log_groups_extract_name" {
    value = aws_cloudwatch_log_group.lambda_log_groups_extract.name
}

output "lambda_log_groups_generate_name" {
    value = aws_cloudwatch_log_group.lambda_log_groups_generate.name
}

output "lambda_log_groups_send_name" {
    value = aws_cloudwatch_log_group.lambda_log_groups_send.name
}

