---
title : "Cấu hình IAM"
date :  "`r Sys.Date()`" 
weight : 4
chapter : false
pre : " <b> 4. </b> "
---


{{< img src="images/5.iam/iam.png" title="iam logo" >}}

### Tổng quan

**AWS IAM (Quản lý danh tính và quyền truy cập)** và **Resource-based policies (Chính sách dựa trên tài nguyên)**

- **AWS IAM** là một dịch vụ cơ bản trong hệ sinh thái **AWS** cho phép bạn quản lý quyền truy cập vào tài nguyên AWS của mình một cách an toàn. Dịch vụ này cung cấp quyền kiểm soát chi tiết đối với những ai có thể truy cập tài nguyên của bạn và những hành động nào họ có thể thực hiện.

- **Resource-based policies** là một loại cơ chế kiểm soát quyền truy cập được đính kèm trực tiếp vào các tài nguyên AWS cụ thể, chẳng hạn như S3, Lambda function hoặc DynamoDB. Các chính sách này xác định ai có thể truy cập tài nguyên và những hành động nào họ được phép thực hiện.
- **Hàm Lambda**: Cấp quyền cho phép gọi các mô hình Amazon Bedrock, knowledge base, agent, gửi email bằng SES, lấy thông tin đơn hàng (DynamoDB) và gửi tin nhắn đến SQS.
- **SQS**: Cho phép SQS có thể kích hoạt lambda function tạo nội dung email, kích hoạt lambda function gửi email.
- **Amazon Bedrock**: Cho phép agent thực hiện việc gọi knowledge base.
- **SES**: Cho phép SES gọi Lambda function để trích xuất email, đưa email lên S3.

### Nội dung

4.1. [Tạo IAM Role cho Lambda functions](4.1-create-lambda-role/)\
4.2. [Tạo IAM Role cho SES](4.2-create-ses-role)
