module "dynamodb" {
  source = "./modules/dynamodb"
}

module "sqs" {
  source = "./modules/sqs"
}

module "iam_roles" {
  source      = "./modules/iam-role"
  bucket_name = var.bucket_name
}

module "log_groups" {
  source = "./modules/cloudwatch"
}

module "lambda" {
  source = "./modules/lambdas"

  iam_extract_email_role_arn  = module.iam_roles.iam_extract_email_role_arn
  iam_generate_email_role_arn = module.iam_roles.iam_generate_email_role_arn
  iam_send_email_role_arn     = module.iam_roles.iam_send_email_role_arn

  lambda_log_groups_extract_name  = module.log_groups.lambda_log_groups_extract_name
  lambda_log_groups_generate_name = module.log_groups.lambda_log_groups_generate_name
  lambda_log_groups_send_name     = module.log_groups.lambda_log_groups_send_name

  generate_sqs_name      = module.sqs.generate_sqs_name
  generate_sqs_arn       = module.sqs.generate_sqs_arn
  send_response_sqs_name = module.sqs.send_sqs_name
  send_response_sqs_arn = module.sqs.send_sqs_arn

  customer_service_agent_id       = module.amazon_bedrock.agent_id
  customer_service_agent_alias_id = module.amazon_bedrock.alias_id
  knowledge_base_id               = module.amazon_bedrock.knowledge_base_id

  bucket_name = var.bucket_name
  source_email = var.source_email
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "ses" {
  source                = "./modules/ses"
  custom_domain         = var.custom_domain
  sender_email          = var.sender_email
  generate_function_arn = module.lambda.generate_function_arn
  bucket_name           = var.bucket_name
  iam_role_ses_s3_arn   = module.iam_roles.iam_role_ses_s3_arn
  depends_on            = [module.s3, module.lambda]
}

################################################################################
# Before run this module, you must request access to the model
################################################################################

module "amazon_bedrock" {
  source             = "./modules/amazon-bedrock"
  bucket_arn         = module.s3.s3_bucket_arn
  document_key       = module.s3.s3_document_key
  iam_role_kb_arn    = module.iam_roles.iam_role_amazon_bedrock_kb_arn
  iam_role_agent_arn = module.iam_roles.iam_role_amazon_bedrock_agent_arn
}
