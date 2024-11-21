locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
  document_path = "../faqs.txt"
}

################################################################################
# S3 static website bucket
################################################################################
resource "aws_s3_bucket" "s3_ai_powered_email_auto_replies" {
  bucket = var.bucket_name
  force_destroy = true # This will be force delete all objects, no need to empty when run terraform destroy command
  tags = merge(local.base_tags, {
    Name = var.bucket_name
  })
}

################################################################################
# S3 folders
################################################################################

resource "aws_s3_object" "raw_email_folder" {
  bucket = aws_s3_bucket.s3_ai_powered_email_auto_replies.id
  key    = "received-email/"
  source = "/dev/null"  # Empty object that acts as a folder
}

resource "aws_s3_object" "generated_email_folder" {
  bucket = aws_s3_bucket.s3_ai_powered_email_auto_replies.id
  key    = "generated-email/"
  source = "/dev/null"  # Empty object that acts as a folder
}

resource "aws_s3_object" "documents_folder" {
  bucket = aws_s3_bucket.s3_ai_powered_email_auto_replies.id
  key    = "documents/"
  source = "/dev/null"  # Empty object that acts as a folder
}

# upload our document for amazon bedrock knowledge base
resource "aws_s3_object" "faq_document" {
  bucket = aws_s3_bucket.s3_ai_powered_email_auto_replies.id
  key    = "documents/faqs.txt"
  source = local.document_path
  etag   = filemd5(local.document_path)
  depends_on = [ aws_s3_object.documents_folder ]
}

################################################################################
# S3 public access settings
################################################################################
resource "aws_s3_bucket_public_access_block" "static_site_bucket_public_access" {
  bucket = aws_s3_bucket.s3_ai_powered_email_auto_replies.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
