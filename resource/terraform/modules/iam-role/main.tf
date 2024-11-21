locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
}

################################################################################
# IAM Role Extract Email
################################################################################

resource "aws_iam_role" "iam_extract_email_role" {
  name = "ExtractEmailRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = merge(local.base_tags, {
    Name = "ExtractEmailRole"
  })
}

resource "aws_iam_role_policy" "extract_email_policy" {
  name = "ExtractEmailRolePolicy"
  role = aws_iam_role.iam_extract_email_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket",
          "sqs:SendMessage",
          "sqs:GetQueueUrl",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

################################################################################
# IAM Role Generate Email
################################################################################

resource "aws_iam_role" "iam_generate_email_role" {
  name = "GenerateEmailRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = merge(local.base_tags, {
    Name = "GenerateEmailRole"
  })
}

resource "aws_iam_role_policy" "generate_email_policy" {
  name = "GenerateEmailRolePolicy"
  role = aws_iam_role.iam_generate_email_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:GetQueueUrl",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetItem",
          "bedrock:InvokeModel",
          "bedrock:ListKnowledgeBases",
          "bedrock:GetKnowledgeBase",
          "bedrock:Retrieve",
          "bedrock:RetrieveAndGenerate",
          "bedrock:ListAgents",
          "bedrock:GetAgent",
          "bedrock:InvokeAgent",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

################################################################################
# IAM Role Send Email
################################################################################

resource "aws_iam_role" "iam_send_email_role" {
  name = "SendEmailRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = merge(local.base_tags, {
    Name = "SendEmailRole"
  })
}

resource "aws_iam_role_policy" "send_email_policy" {
  name = "SendEmailRolePolicy"
  role = aws_iam_role.iam_send_email_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:GetQueueUrl",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "ses:SendEmail",
          "ses:SendRawEmail",
          "s3:ListBucket",
          "s3:PutObject",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}


################################################################################
# IAM Role SES
################################################################################

resource "aws_iam_role" "ses_s3" {
  name = "ses_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ses.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ses_s3_policy" {
  name = "ses_s3_policy"
  role = aws_iam_role.ses_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = ["arn:aws:s3:::${var.bucket_name}/*"]
      }
    ]
  })
}

################################################################################
# IAM Role Amazon Bedrock Knowleged Base
################################################################################

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "iam_role_bedrock_knowledge_base" {
  name = "AmazonBedrockKnowledgeBaseRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AmazonBedrockKnowledgeBaseTrustPolicy"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:knowledge-base/*"
          }
        }
      }
    ]
  })

  tags = merge(local.base_tags, {
    Name = "BedrockKnowledgeBaseRole"
  })
}

data "aws_bedrock_foundation_model" "this" {
  model_id = "amazon.titan-embed-text-v1"
}

resource "aws_iam_role_policy" "bedrock_knowledge_base_policy" {
  name = "BedrockKnowledgeBasePolicy"
  role = aws_iam_role.iam_role_bedrock_knowledge_base.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BedrockInvokeModelStatement"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = [
          data.aws_bedrock_foundation_model.this.model_arn
        ]
      },
      {
        Sid    = "OpenSearchServerlessAPIAccessAllStatement"
        Effect = "Allow"
        Action = [
          "aoss:APIAccessAll"
        ]
        Resource = [
          "arn:aws:aoss:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:collection/*"
        ]
      },
      {
        Sid    = "S3ListBucketStatement"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = ["*"]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "S3GetObjectStatement"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "*"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

################################################################################
# IAM Role Amazon Bedrock Agent
################################################################################

resource "aws_iam_role" "iam_role_bedrock_agent" {
  name = "AmazonBedrockAgentRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/*"
          }
        }
      }
    ]
  })

  tags = merge(local.base_tags, {
    Name = "BedrockAgentRole"
  })
}

resource "aws_iam_role_policy" "bedrock_agent_policy" {
  name = "BedrockAgentPolicy"
  role = aws_iam_role.iam_role_bedrock_agent.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AmazonBedrockAgentBedrockFoundationModelPolicyProd",
        Effect = "Allow",
        Action = "bedrock:InvokeModel",
        Resource = [
          "arn:aws:bedrock:${data.aws_region.current.name}::foundation-model/*"
        ]
      },
      {
        Sid    = "AmazonBedrockAgentRetrieveKnowledgeBasePolicyProd",
        Effect = "Allow",
        Action = [
          "bedrock:Retrieve"
        ],
        Resource = [
          "arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:knowledge-base/*"
        ]
      }
    ]
  })
}
