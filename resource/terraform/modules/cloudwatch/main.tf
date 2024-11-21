locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
}

################################################################################
# Cloudwatch logs for lambda
################################################################################

resource "aws_cloudwatch_log_group" "lambda_log_groups_extract" {
  name              = "/aws/lambda/ExtractEmailFunction"
  retention_in_days = 14
  tags              = merge(local.base_tags, {
    name = "cloudwatch_ExtractEmailFunction"
  })
}

resource "aws_cloudwatch_log_group" "lambda_log_groups_generate" {
  name              = "/aws/lambda/GenerateEmailFunction"
  retention_in_days = 14
  tags              = merge(local.base_tags, {
    name = "cloudwatch_GenerateEmailFunction"
  })
}

resource "aws_cloudwatch_log_group" "lambda_log_groups_send" {
  name              = "/aws/lambda/SendEmailFunction"
  retention_in_days = 14
  tags              = merge(local.base_tags, {
    name = "cloudwatch_SendEmailFunction"
  })
}

