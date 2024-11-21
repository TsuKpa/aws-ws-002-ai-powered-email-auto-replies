locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
  collection_name = "amz-bedrock-collection"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

// https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html
data "aws_bedrock_foundation_model" "this" {
  model_id = "amazon.titan-embed-text-v1"
}

################################################################################
# OpenSearch Serverless
################################################################################

resource "aws_opensearchserverless_security_policy" "encryption_policy" {
  name        = local.collection_name
  type        = "encryption"
  description = "Encryption policy for ${local.collection_name}"
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/${local.collection_name}"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

resource "aws_opensearchserverless_security_policy" "network_policy" {
  name        = local.collection_name
  type        = "network"
  description = "Network policy for ${local.collection_name}"
  policy = jsonencode([{
    Description = "Public access to collection and Dashboards endpoint for example collection",
    Rules = [
      {
        ResourceType = "collection",
        Resource     = ["collection/${local.collection_name}"]
      },
      {
        ResourceType = "dashboard"
        Resource     = ["collection/${local.collection_name}"]
      }
    ],
    AllowFromPublic = true
  }])
}

resource "aws_opensearchserverless_access_policy" "access_policy" {
  name        = local.collection_name
  type        = "data"
  description = "Read and write permissions"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index",
          Resource = [
            "index/${local.collection_name}/*"
          ],
          Permission = [
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:UpdateIndex",
            "aoss:WriteDocument"
          ]
        },
        {
          ResourceType = "collection",
          Resource = [
            "collection/${local.collection_name}"
          ],
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DescribeCollectionItems",
            "aoss:UpdateCollectionItems"
          ]
        }
      ],
      Principal = [
        data.aws_caller_identity.current.arn,
        var.iam_role_kb_arn
      ]
    }
  ])
}

resource "aws_opensearchserverless_collection" "opensearch_customer_service_collection" {
  name = local.collection_name
  type = "VECTORSEARCH"

  tags = merge(local.base_tags, {
    Name = local.collection_name
  })

  depends_on = [
    aws_opensearchserverless_security_policy.encryption_policy,
    aws_opensearchserverless_access_policy.access_policy,
    aws_opensearchserverless_security_policy.network_policy
  ]
}

provider "opensearch" {
  url         = aws_opensearchserverless_collection.opensearch_customer_service_collection.collection_endpoint
  healthcheck = false
}

resource "opensearch_index" "customer_service_index" {
  provider                       = opensearch
  name                           = "bedrock-knowledge-base-default-index"
  number_of_shards               = "2"
  number_of_replicas             = "0"
  index_knn                      = true
  index_knn_algo_param_ef_search = "512"
  mappings                       = <<-EOF
    {
      "properties": {
        "bedrock-knowledge-base-default-vector": {
          "type": "knn_vector",
          "dimension": 1536,
          "method": {
            "name": "hnsw",
            "engine": "faiss",
            "parameters": {
              "m": 16,
              "ef_construction": 512
            },
            "space_type": "l2"
          }
        },
        "AMAZON_BEDROCK_METADATA": {
          "type": "text",
          "index": "false"
        },
        "AMAZON_BEDROCK_TEXT_CHUNK": {
          "type": "text",
          "index": "true"
        }
      }
    }
  EOF
  force_destroy                  = true
  depends_on                     = [aws_opensearchserverless_collection.opensearch_customer_service_collection]
}

################################################################################
# Knowledge base
################################################################################

// Need to wait for creating index before create knowledge base
resource "time_sleep" "waiting_before_continue" {
  create_duration = "20s"
  depends_on      = [opensearch_index.customer_service_index]
}

resource "aws_bedrockagent_knowledge_base" "email_auto_reply_kb" {
  name        = "email-auto-reply-kb"
  description = "Knowledge base for email auto replies using FAQ document"
  role_arn    = var.iam_role_kb_arn

  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = aws_opensearchserverless_collection.opensearch_customer_service_collection.arn
      vector_index_name = "bedrock-knowledge-base-default-index"
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = data.aws_bedrock_foundation_model.this.model_arn
    }
  }

  tags = merge(local.base_tags, {
    Name = "email-auto-reply-kb"
  })

  depends_on = [aws_opensearchserverless_collection.opensearch_customer_service_collection, time_sleep.waiting_before_continue]
}

resource "aws_bedrockagent_data_source" "faq_data_source" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.email_auto_reply_kb.id
  name              = "faq-document"
  description       = "FAQ document data source"

  data_source_configuration {
    type = "S3"
    s3_configuration {
      inclusion_prefixes = [var.document_key]
      bucket_arn         = var.bucket_arn
    }
  }

  depends_on = [aws_bedrockagent_knowledge_base.email_auto_reply_kb]
}

################################################################################
# Sync datasource
################################################################################

resource "null_resource" "sync_data_source" {
  provisioner "local-exec" {
    command = "aws bedrock-agent start-ingestion-job --data-source-id=${aws_bedrockagent_data_source.faq_data_source.data_source_id} --knowledge-base-id=${aws_bedrockagent_knowledge_base.email_auto_reply_kb.id} --region=${data.aws_region.current.name}"
  }

  depends_on = [aws_bedrockagent_knowledge_base.email_auto_reply_kb, aws_bedrockagent_data_source.faq_data_source]
}

################################################################################
# Agent and knowledge base association
################################################################################

resource "aws_bedrockagent_agent" "customer_service_agent" {
  agent_name                  = "customer_service_agent"
  agent_resource_role_arn     = var.iam_role_agent_arn
  idle_session_ttl_in_seconds = 500
  // https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html#model-ids-arns
  foundation_model = "anthropic.claude-3-haiku-20240307-v1:0"
  description      = "You are the agent of our cat shop, use the knowledge base to help the customer"
  instruction      = "You are a customer service agent skilled at handling general inquiries, account questions, and non-technical support requests from customers. Your role is to provide helpful and polite responses by searching a comprehensive knowledge base and formatting your responses in a professional email style."
  tags = merge(local.base_tags, {
    Name = "email-auto-reply-agent"
  })

  depends_on = [aws_bedrockagent_data_source.faq_data_source, null_resource.sync_data_source]
}

resource "time_sleep" "waiting_before_continue_2" {
  create_duration = "20s"
  depends_on      = [aws_bedrockagent_agent.customer_service_agent]
}

resource "aws_bedrockagent_agent_knowledge_base_association" "customer_service_kb_association" {
  agent_id             = aws_bedrockagent_agent.customer_service_agent.id
  description          = "Use this knowledge base to retrieve information on Cat shop"
  knowledge_base_id    = aws_bedrockagent_knowledge_base.email_auto_reply_kb.id
  knowledge_base_state = "ENABLED"

  depends_on = [
    aws_bedrockagent_knowledge_base.email_auto_reply_kb,
    aws_bedrockagent_agent.customer_service_agent,
    time_sleep.waiting_before_continue_2
  ]
}

################################################################################
# Agent Preparation And Alias
################################################################################

resource "time_sleep" "waiting_before_continue_3" {
  create_duration = "20s"
  depends_on      = [aws_bedrockagent_agent_knowledge_base_association.customer_service_kb_association]
}

resource "aws_bedrockagent_agent_alias" "email_agent_alias" {
  agent_alias_name = "email_agent_alias"
  agent_id         = aws_bedrockagent_agent.customer_service_agent.id
  description      = "You are a helpful agent that can answer question about our cat shop service, response with email format"

  tags = merge(local.base_tags, {
    Name = "email-auto-reply-agent-alias"
  })

  depends_on = [
    aws_bedrockagent_agent.customer_service_agent,
    aws_bedrockagent_agent_knowledge_base_association.customer_service_kb_association,
    time_sleep.waiting_before_continue_3
  ]
}

resource "null_resource" "aws_bedrockagent_agent_asst_prepare" {
  provisioner "local-exec" {
    command = "aws bedrock-agent prepare-agent --agent-id ${aws_bedrockagent_agent.customer_service_agent.id} --region=${data.aws_region.current.name}"
  }
  depends_on = [
    aws_bedrockagent_agent.customer_service_agent,
    aws_bedrockagent_knowledge_base.email_auto_reply_kb,
    aws_bedrockagent_agent_knowledge_base_association.customer_service_kb_association,
    aws_bedrockagent_agent_alias.email_agent_alias
  ]
}
