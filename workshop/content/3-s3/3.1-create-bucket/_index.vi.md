---
title : "Tạo S3 bucket"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 3.1. </b> "
---

1. Tại **AWS Console**, tìm kiếm từ khoá *"s3"* và chọn **S3**, bởi vì đa số model của Amazon Bedrock đều khả dụng ở region `us-east-1` vì thế nên chúng ta sẽ chọn region `us-east-1` cho ứng dụng.

{{< img src="images/3.s3/1.png" title="01-s3" >}}

2. Chọn **"Create Bucket"**

{{< img src="images/3.s3/1.1.png" title="choose create bucket" >}}

3. Trong màn hình tạo bucket, chúng ta chọn:

   - Chọn **"us-east-1"**
   - Nhập tên bucket `ai-powered-email-auto-replies` <--- Vui lòng ghi nhớ tên bucket

{{% notice info %}}
**Tên Bucket** là duy nhất.
{{% /notice %}}

{{< img src="images/3.s3/2.png" title="enter bucket name" >}}

4. Để setting mặc định

{{< img src="images/3.s3/3.png" title="default settings" >}}

5. Cuối cùng, kéo xuống vàj chọn **"Create Bucket"** đẻ hoàn tất

{{< img src="images/3.s3/4.png" title="choose create bucket" >}}
