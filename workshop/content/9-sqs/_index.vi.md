---
title : "Cấu hình SQS"
date : "`r Sys.Date()`"
weight : 9
chapter : false
pre : " <b> 9. </b> "
---

{{< img src="images/9.sqs/logo.svg" title="SQS logo" >}}

### Tổng quan

**Amazon Simple Queue Service (SQS)** là dịch vụ message queue được quản lý, cho phép tách rời và mở rộng quy mô các hệ thống phân tán và ứng dụng không có máy chủ. Dịch vụ này cung cấp một trung gian đáng tin cậy, có tính khả dụng cao để gửi tin nhắn giữa các thành phần ứng dụng.

Lợi ích chính:

- **Decouple components**: SQS cho phép các phần khác nhau của ứng dụng phân tán chạy độc lập
- **Xử lý thông lượng cao**: Có thể xử lý hàng nghìn tin nhắn mỗi giây
- **At-least-once delivery**: Tin nhắn được lưu trữ dự phòng trên nhiều AZ
- **Configurable retention**: Tin nhắn có thể được lưu trữ tới 14 ngày
- **Tiết kiệm chi phí**: Chỉ trả tiền cho các yêu cầu bạn thực hiện
- **Managed service**: Không cần cung cấp hoặc quản lý máy chủ

Các trường hợp sử dụng phổ biến:

- **Tách rời khối lượng công việc**: Tách nhà sản xuất khỏi người tiêu dùng
- **Xử lý hàng loạt**: Thu thập và xử lý tin nhắn theo từng đợt
- **Request buffering**: Xử lý lưu lượng truy cập tăng đột biến bằng cách xếp hàng các yêu cầu
- **Kiến trúc phân tán**: Phân phối tin nhắn cho nhiều người tiêu dùng
- **Job queues**: Điều phối xử lý công việc phân tán
- **Microservices**: Nhắn tin không đồng bộ đáng tin cậy giữa các dịch vụ

Trong workshops này, chúng ta sẽ sử dụng SQS để tách rời các Lambda function cho việc xử lý email:
- Generate email response queue (Tạo nội dung phản hồi khi có mail mới)
- Send email (Gửi mail phản hồi)

Kiến trúc này cho phép mỗi chức năng xử lý tin nhắn theo tốc độ riêng của nó trong khi vẫn đảm bảo việc truyền tin nhắn đáng tin cậy giữa các thành phần.

### Nội dung

Bây giờ chúng ta sẽ cùng tạo chúng

#### Generate email response queue

1. Ở mục **AWS Console**, tìm kiếm *"sqs"* và chọn **Simple Queue Service**

{{< img src="images/9.sqs/1.png" title="sqs1" >}}

2. Chọn **Create queue**

{{< img src="images/9.sqs/2.png" title="sqs2" >}}

3. Chúng ta sử dụng cấu hình mặc định, nhập `sqs-generate-email-content-queue` ở phần Name

{{< img src="images/9.sqs/3.png" title="sqs3" >}}

4. Chọn **Create queue**

{{< img src="images/9.sqs/4.png" title="sqs4" >}}

5. Tạo thành công, tiếp theo chúng ta cần thêm lambda function trigger mỗi khi có email đến, chọn **Lambda triggers**

{{< img src="images/9.sqs/5.png" title="sqs5" >}}

6. Chọn **Configure Lambda function trigger**

{{< img src="images/9.sqs/6.png" title="sqs6" >}}

7. Chọn Generate Email Lambda chúng ta đã tạo ở bước 8.2, chọn **Save**

{{< img src="images/9.sqs/7.png" title="sqs7" >}}

8. Như bạn đã thấy chúng ta đã thêm lambda function thành công

{{< img src="images/9.sqs/8.png" title="sqs8" >}}

#### Send email queue

Queue này cũng tương tự, bạn hãy giúp tôi tạo chúng

- Name: `sqs-send-email-to-customer-queue`
- Trigger Lambda function: `SendEmailLambda`

{{< img src="images/9.sqs/9.png" title="sqs9" >}}