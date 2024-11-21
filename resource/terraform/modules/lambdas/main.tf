locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
  extract_email_path  = "../lambda/extract-email"
  generate_email_path = "../lambda/generate-email"
  send_email_path     = "../lambda/send-email"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

################################################################################
# Extract email content lambda function
################################################################################

#Install NPM module and build before creating ZIP
resource "null_resource" "npm_and_build_extract_email" {
  provisioner "local-exec" {
    command = "cd ${local.extract_email_path} && npm install --omit=dev && sam build"
  }
}

# Zip the Lamda function on the fly
data "archive_file" "extract_email_source" {
  type        = "zip"
  source_dir  = "${local.extract_email_path}/.aws-sam/build/ExtractEmailLambda/"
  output_path = "${local.extract_email_path}/index.zip"
  depends_on  = [null_resource.npm_and_build_extract_email]
}

resource "aws_lambda_function" "extract_email_content" {
  function_name = "extract-email-lambda"
  role          = var.iam_extract_email_role_arn
  # As of January 2024, Node.js 20.x is supported in AWS Lambda
  # See: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime     = "nodejs20.x"
  handler     = "index.handler"
  memory_size = 128
  timeout     = 30

  source_code_hash = data.archive_file.extract_email_source.output_base64sha256
  filename         = data.archive_file.extract_email_source.output_path

  logging_config {
    log_group  = var.lambda_log_groups_extract_name
    log_format = "JSON"
  }

  environment {
    variables = {
      QUEUE_NAME  = var.generate_sqs_name
      BUCKET_NAME = var.bucket_name
    }
  }

  tags = merge(local.base_tags, {
    Name = "extract-email-lambda"
  })

  depends_on = [null_resource.npm_and_build_extract_email]
}

// Amazon SES must have permissions to execute the Lambda function. 
// This is done by adding a policy to the resource-based policy of your Lambda function.
resource "aws_lambda_permission" "allow_ses" {
  statement_id  = "AllowSESInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.extract_email_content.function_name
  principal     = "ses.amazonaws.com"
  source_arn    = "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
}

################################################################################
# Generate email content lambda function (Calling Amazon Bedrock)
################################################################################

#Install NPM module and build before creating ZIP
resource "null_resource" "npm_and_build_generate_email" {
  provisioner "local-exec" {
    command = "cd ${local.generate_email_path} && npm install --omit=dev && sam build"
  }
}

# Zip the Lamda function on the fly
data "archive_file" "generate_email_source" {
  type        = "zip"
  source_dir  = "${local.generate_email_path}/.aws-sam/build/GenerateEmailLambda/"
  output_path = "${local.generate_email_path}/index.zip"
  depends_on  = [null_resource.npm_and_build_generate_email]
}

resource "aws_lambda_function" "generate_email_content" {
  function_name = "generate-email-lambda"
  role          = var.iam_generate_email_role_arn

  # As of January 2024, Node.js 20.x is supported in AWS Lambda
  # See: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime     = "nodejs20.x"
  handler     = "index.handler"
  memory_size = 1024
  timeout     = 30

  source_code_hash = data.archive_file.generate_email_source.output_sha256
  filename         = data.archive_file.generate_email_source.output_path

  logging_config {
    log_group  = var.lambda_log_groups_generate_name
    log_format = "JSON"
  }

  environment {
    variables = {
      ENV                             = "prod"
      CUSTOMER_SERVICE_AGENT_ID       = var.customer_service_agent_id
      CUSTOMER_SERVICE_AGENT_ALIAS_ID = var.customer_service_agent_alias_id
      KNOWLEDGE_BASE_ID               = var.knowledge_base_id,
      RESPONSE_QUEUE_NAME             = var.send_response_sqs_name
      NODE_OPTIONS                    = "--enable-source-maps --max_old_space_size=8192"
    }
  }

  tags = merge(local.base_tags, {
    Name = "generate-email-lambda"
  })

  depends_on = [null_resource.npm_and_build_generate_email, data.archive_file.generate_email_source]
}

// Amazon SQS must have permissions to execute the Lambda function. 
resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowSQSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_email_content.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
}

// Trigger lambda when receive message from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = var.generate_sqs_arn
  enabled          = true
  function_name    = aws_lambda_function.generate_email_content.arn
  batch_size       = 5
}

################################################################################
# Send email lambda function
################################################################################


#Install NPM module and build before creating ZIP
resource "null_resource" "npm_and_build_send_email" {
  provisioner "local-exec" {
    command = "cd ${local.send_email_path} && npm install --omit=dev && sam build"
  }
}

# Zip the Lamda function on the fly
data "archive_file" "send_email_source" {
  type        = "zip"
  source_dir  = "${local.send_email_path}/.aws-sam/build/SendEmailLambda/"
  output_path = "${local.send_email_path}/index.zip"
  depends_on  = [null_resource.npm_and_build_send_email]
}

resource "aws_lambda_function" "send_email_lambda" {
  function_name = "send-email-lambda"
  role          = var.iam_send_email_role_arn

  # As of January 2024, Node.js 20.x is supported in AWS Lambda
  # See: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime     = "nodejs20.x"
  handler     = "index.handler"
  memory_size = 128
  timeout     = 30

  source_code_hash = data.archive_file.send_email_source.output_sha256
  filename         = data.archive_file.send_email_source.output_path

  logging_config {
    log_group  = var.lambda_log_groups_send_name
    log_format = "JSON"
  }

  environment {
    variables = {
      SOURCE_EMAIL = var.source_email,
      BUCKET_NAME  = var.bucket_name
      NODE_OPTIONS = "--enable-source-maps --max_old_space_size=8192"
    }
  }

  tags = merge(local.base_tags, {
    Name = "send-email-lambda"
  })

  depends_on = [null_resource.npm_and_build_send_email, data.archive_file.send_email_source]
}

// Amazon SQS must have permissions to execute the Lambda function. 
resource "aws_lambda_permission" "allow_sqs_trigger_send_email" {
  statement_id  = "AllowSQSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email_lambda.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
}

// Trigger lambda when receive message from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping_send_email" {
  event_source_arn = var.send_response_sqs_arn
  enabled          = true
  function_name    = aws_lambda_function.send_email_lambda.arn
  batch_size       = 5
}
