---
title : "Xoá tài nguyên"
date : "`r Sys.Date()`"
weight : 11
chapter : false
pre : " <b> 11. </b> "
---

Chúng ta cần làm một vài thao tác để xoá dịch vụ đã sử dụng

### Xoá Amazon Bedrock

1. Vào **Amazon Bedrock** service -> Chọn agent alias -> **Delete**
{{< img src="images/11.clean/1.png" title="1" >}}

2. Nhập "delete" -> **Delete**
{{< img src="images/11.clean/2.png" title="2" >}}

3. Vào **Knowledge base** service -> Chọn knowledge base -> **Delete**
{{< img src="images/11.clean/3.png" title="3" >}}

4. Nhập "delete" -> **Delete**
{{< img src="images/11.clean/4.png" title="4" >}}

5. Chúng ta cũng cần vào vector store database để xoá phần còn lại (Phần này tính tiền theo giờ nhé ~1$/h). Vào **OpenSearch** service
{{< img src="images/11.clean/5.png" title="5" >}}

6. Ở mục Serverless -> Collections -> Chọn collection -> **Delete**
{{< img src="images/11.clean/6.png" title="6" >}}

7. Nhập "confirm" -> **Delete**
{{< img src="images/11.clean/7.png" title="7" >}}

### Xoá SQS

1. Vào "SQS" service -> Chọn 2 queues đã tạo -> **Delete**
{{< img src="images/11.clean/8.png" title="8" >}}

2. Nhập "confirm" -> **Delete**
{{< img src="images/11.clean/9.png" title="9" >}}

### Xoá Lambda functions

1. Vào "Lambda" service -> Chọn checkbox tất cả -> **Actions** -> **Delete**
{{< img src="images/11.clean/10.png" title="10" >}}

2. Nhập "confirm" -> **Delete**
{{< img src="images/11.clean/11.png" title="11" >}}

### Xoá S3 bucket

1. Vào "S3" service -> Chọn bucket -> **Empty**
{{< img src="images/11.clean/12.png" title="12" >}}

2. Nhập "permanently delete" -> **Empty**
{{< img src="images/11.clean/13.png" title="13" >}}

3. Empty thành công! kế tiếp, chúng ta sẽ xoá bucket
{{< img src="images/11.clean/14.png" title="14" >}}

4. Chọn bucket -> **Delete**
{{< img src="images/11.clean/15.png" title="15" >}}

5. Nhập tên bucket -> **Delete bucket**
{{< img src="images/11.clean/16.png" title="16" >}}

### Xoá SES

1. Vào "SES" service -> **Configuration** -> **Identities** -> Check all -> **Delete**
{{< img src="images/11.clean/17.png" title="17" >}}

2. Xác nhận để hoàn tất
{{< img src="images/11.clean/18.png" title="18" >}}

