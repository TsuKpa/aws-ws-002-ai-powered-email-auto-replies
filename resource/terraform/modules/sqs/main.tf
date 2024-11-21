locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
}

################################################################################
# SQS for Generate email content
################################################################################

# module "sqs_generate_email_content_dead_letter_queue" {
#   source = "terraform-aws-modules/sqs/aws"
#   version = "~> 3.0"

#   name = "sqs-generate-email-content-dead-letter-queue"

#   tags = local.base_tags
# }

module "sqs_generate_email_content_queue" {
  source = "terraform-aws-modules/sqs/aws"
  version = "~> 3.0"

  name = "sqs-generate-email-content-queue"

  tags = merge(local.base_tags, {
    Name = "sqs-generate-email-content-queue"
  })
}

################################################################################
# SQS for send email to customer
################################################################################

# module "sqs_send_email_to_customer_dead_letter_queue" {
#   source = "terraform-aws-modules/sqs/aws"
#   version = "~> 3.0"

#   name = "sqs-send-email-to-customer-dead-letter-queue"

#   tags = local.base_tags
# }

module "sqs_send_email_to_customer_queue" {
  source = "terraform-aws-modules/sqs/aws"
  version = "~> 3.0"

  name = "sqs-send-email-to-customer-queue"

  tags = merge(local.base_tags, {
    Name = "sqs-send-email-to-customer-queue"
  })
}
