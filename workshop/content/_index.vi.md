---
title : "Xây dựng hệ thống serverless tự động hoá trả lời email cho doanh nghiệp bằng Amazon Bedrock"
date :  "`r Sys.Date()`"
weight : 1
chapter : false
---

## Xây dựng hệ thống serverless tự động hoá trả lời email cho doanh nghiệp bằng Amazon Bedrock

### Tổng quan

Trong workshop này, tôi sẽ hướng dẫn các bạn cách tạo và thực hành sử dụng Amazon Bedrock, Lambda function, nhận và gửi email bằng SES, query dữ liệu với DynamoDB, gửi và xử lý tin nhắn với SQS. Thực hiện việc tạo ứng dụng serverless.

{{< img src="images/infrastructure.svg" title="Infrastructure" >}}

### Nội dung

 1. [Giới thiệu](1-introduction/)
 2. [Chuẩn bị](2-preparation/)
 3. [Cấu hình S3](3-s3/)
 4. [Cấu hình IAM](4-iam/)
 5. [Cấu hình SES](5-ses/)
 6. [Cấu hình Amazon Bedrock](6-amazon-bedrock)
 7. [Cấu hình DynamoDB](7-dynamodb)
 8. [Cấu hình Lambda](8-lambda)
 9. [Cấu hình SQS](9-sqs)
 10. [Kiểm tra kết quả](10-result/)
 11. [Xoá tài nguyên](11-cleanup/)
 12. [IaC-Terraform](12-terraform)
