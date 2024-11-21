output "generate_sqs_name" {
    value = module.sqs_generate_email_content_queue.sqs_queue_name
}

output "generate_sqs_arn" {
    value = module.sqs_generate_email_content_queue.sqs_queue_arn
}

output "send_sqs_name" {
    value = module.sqs_send_email_to_customer_queue.sqs_queue_name
}

output "send_sqs_arn" {
    value = module.sqs_send_email_to_customer_queue.sqs_queue_arn
}


