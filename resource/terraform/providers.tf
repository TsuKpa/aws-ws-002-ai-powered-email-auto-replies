###############################
# Provider
###############################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.1"
    }
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "2.3.1"
    }
  }
  required_version = ">= 1.7.0"
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile_name
}
