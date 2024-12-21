---
title : "Cấu hình Lambda Functions"
date : "`r Sys.Date()`"
weight : 8
chapter : false
pre : " <b> 8. </b> "
---

{{< img src="images/8.lambda/logo.png" title="Lambda logo" >}}

### Tổng quan

**Amazon Lambda function** là dịch vụ điện toán serverless cho phép bạn chạy code mà không cần cung cấp hoặc quản lý máy chủ. Bạn chỉ cần tải source code của mình lên và Lambda sẽ xử lý mọi thứ cần thiết để chạy và mở rộng ứng dụng của bạn.

- Lợi ích khi sử dụng hàm Lambda:

- **Kiến trúc serverless**: Không cần quản lý máy chủ.
- **Giá theo mức sử dụng**: Chỉ trả tiền cho tài nguyên bạn đã sử dụng.
- **Tự động mở rộng**: Tự động phản hồi các yêu cầu thực thi mã ở mọi quy mô, từ hàng chục sự kiện mỗi ngày đến hàng trăm nghìn sự kiện mỗi giây..
- **Triển khai nhanh**: Triển khai mã nhanh chóng và dễ dàng.
- **Tích hợp với các dịch vụ AWS khác**: Tích hợp liền mạch với nhiều dịch vụ AWS khác nhau.

- Các trường hợp sử dụng phổ biến: Xử lý dữ liệu, Ứng dụng thời gian thực, Web và Nền tảng di động, Xử lý hình ảnh và video, Học máy,...

### Nội dung

Trong workshop này, chúng ta sẽ tạo 3 Lambda function:

8.1. [Tạo Extract Email Function](8.1-extract-email-function/)\
8.2. [Tạo Generate Email Function](8.2-generate-email-function/)\
8.3. [Tạo Send Email Function](8.3-send-email-function)
