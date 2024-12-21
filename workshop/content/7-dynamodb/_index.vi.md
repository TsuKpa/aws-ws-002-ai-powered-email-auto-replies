---
title : "Cấu hình DynamoDB"
date : "`r Sys.Date()`"
weight : 7
chapter : false
pre : " <b> 7. </b> "
---

{{< img src="images/7.dynamodb/dynamodb.jpeg" title="dynamodb logo" >}}

### Tổng quan

**Amazon DynamoDB** là dịch vụ cơ sở dữ liệu NoSQL không máy chủ cho phép bạn phát triển các ứng dụng hiện đại ở mọi quy mô.

Là một cơ sở dữ liệu không máy chủ, bạn chỉ trả tiền cho những gì bạn sử dụng và **DynamoDB** mở rộng đến mức không, không có khởi động nguội, không có nâng cấp phiên bản, không có cửa sổ bảo trì, không có bản vá và không có bảo trì thời gian chết.

**DynamoDB** cung cấp một bộ rộng các biện pháp kiểm soát bảo mật và tiêu chuẩn tuân thủ. Đối với các ứng dụng phân tán toàn cầu, **DynamoDB** bảng toàn cầu là cơ sở dữ liệu đa vùng, đa hoạt động với SLA khả dụng 99,999% và khả năng phục hồi được tăng cường.

**Độ tin cậy của DynamoDB** được hỗ trợ với các bản sao lưu được quản lý, phục hồi tại một thời điểm và nhiều hơn nữa.

{{% notice note %}}
Trong workshop này thì tôi chỉ mô phỏng 1 phần của hệ thống bán hàng :)
{{% /notice %}}

### Nội dung

7.1. [Tạo bảng Orders](7.1-create-orders-table/)\
7.2. [Tạo bảng Shipments](7.2-create-shipments-table/)
