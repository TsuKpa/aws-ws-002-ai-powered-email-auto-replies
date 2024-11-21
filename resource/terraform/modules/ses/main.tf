locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
}
data "aws_caller_identity" "current" {}

################################################################################
# Create SES for receiving email
################################################################################

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.custom_domain
}

resource "aws_ses_email_identity" "sender" {
  email = var.sender_email
}

resource "aws_ses_receipt_rule_set" "ses_rule_set" {
  rule_set_name = "ses_rule_set"
}

# To make a rule set active, you need to create aws_ses_active_receipt_rule_set resource
resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = aws_ses_receipt_rule_set.ses_rule_set.rule_set_name
}

resource "aws_ses_receipt_rule" "store" {
  name          = "store_email"
  rule_set_name = aws_ses_receipt_rule_set.ses_rule_set.rule_set_name
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name       = var.bucket_name
    object_key_prefix = "received-email/"
    iam_role_arn      = var.iam_role_ses_s3_arn
    position          = 1
  }

  lambda_action {
    function_arn    = var.generate_function_arn
    invocation_type = "Event"
    position        = 2
  }
}

################################################################################
# NOTE: After created this module, you need to verify at the AWS SES Console
# - Domain: You need to add MX record from your custom domain
# - Sender: You need to verify sender email address by clicking the link in your email dashboard
################################################################################
