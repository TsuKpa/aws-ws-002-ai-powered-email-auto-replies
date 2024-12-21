---
title : "Tạo thư mục"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 3.2. </b> "
---

Ở section này, chúng ta sẽ tạo 3 thư mục:

- `received-email`: Thư mục này sẽ lưu trữ email gửi đến
- `documents`: Thư mục này sẽ lưu tài liệu `faqs.txt`, tài liệu này dùng để huấn luyện AI knowledge base về điều khoản, phương thức thanh toán...
- `generated-email`: Thư mục này dùng để lưu nội dung đã gửi

1. Sau khi tạo xong thì chúng ta chọn bucket đã tạo `ai-powered-email-auto-replies`

{{< img src="images/3.s3/5.png" title="choose our bucket" >}}

2. Chọn **"Create folder"**

{{< img src="images/3.s3/6.png" title="Create folder" >}}

3. Nhập tên thư mục đầu tiên `received-email` vào **Folder name** và chọn **"Create folder"**

{{< img src="images/3.s3/7-1.png" title="create first folder" >}}

4. Lập lại **Bước 3** để tạo 2 thư mục còn lại `documents`, `generated-email`.

{{< img src="images/3.s3/8-1.png" title="create remaining folders" >}}
