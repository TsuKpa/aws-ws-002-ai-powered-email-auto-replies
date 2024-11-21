output "aws_dynamodb_table_orders_arn" {
    value = aws_dynamodb_table.orders.arn
}

output "aws_dynamodb_table_shipments_arn" {
    value = aws_dynamodb_table.shipments.arn
}
