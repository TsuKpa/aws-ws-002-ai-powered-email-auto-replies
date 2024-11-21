locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
}

################################################################################
# DynamoDB table for getting order
################################################################################

resource "aws_dynamodb_table" "orders" {
  name           = "orders"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "orderId"
  
  attribute {
    name = "orderId"
    type = "S"
  }

  tags = merge(local.base_tags, {
    Name = "orders-table"
  })
}

locals {
  order_items = {
    sample_1 = {
      orderId = "12345"
      status = "DELIVERED"
      items = ["Widget A", "Gadget B"]
      total = 150.00
    }
    sample_2 = {
      orderId = "67890"
      status = "PROCESSING" 
      items = ["Gizmo C"]
      total = 75.50
    }
  }
}

resource "aws_dynamodb_table_item" "order_samples" {
  for_each = local.order_items
  
  table_name = aws_dynamodb_table.orders.name
  hash_key   = aws_dynamodb_table.orders.hash_key

  item = jsonencode({
    orderId = { S = each.value.orderId }
    status = { S = each.value.status }
    items = { L = [for item in each.value.items : { S = item }] }
    total = { N = tostring(each.value.total) }
  })
}
################################################################################
# DynamoDB table for getting shipments
################################################################################

resource "aws_dynamodb_table" "shipments" {
  name           = "shipments" 
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "orderId"

  attribute {
    name = "orderId"
    type = "S"
  }

  tags = merge(local.base_tags, {
    Name = "shipments-table"
  })
}

// Sample DynamoDB item:
locals {
  shipment_items = {
    sample_1 = {
      orderId = "12345"
      carrier = "FastShip"
      trackingNumber = "FS123456789"
      status = "IN_TRANSIT"
    }
    sample_2 = {
      orderId = "67890"
      carrier = "QuickPost" 
      trackingNumber = "QP987654321"
      status = "DELIVERED"
    }
    sample_3 = {
      orderId = "24680"
      carrier = "ExpressLine"
      trackingNumber = "EL456789123"
      status = "PROCESSING"
    }
  }
}

resource "aws_dynamodb_table_item" "shipment_samples" {
  for_each = local.shipment_items
  
  table_name = aws_dynamodb_table.shipments.name
  hash_key   = aws_dynamodb_table.shipments.hash_key

  item = jsonencode({
    orderId = { S = each.value.orderId }
    carrier = { S = each.value.carrier }
    trackingNumber = { S = each.value.trackingNumber }
    status = { S = each.value.status }
  })
} 
