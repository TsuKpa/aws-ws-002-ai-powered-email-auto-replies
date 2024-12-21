---
title : "Tạo Domain identity"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

1. Ở **AWS Console**, tìm kiếm *"ses"* và chọn **Amazon Simple Email Service**

{{< img src="images/4.ses/1.png" title="ses" >}}

2. Ở panel bên trái, chọn **"Identities"**

{{< img src="images/4.ses/2.png" title="identities" >}}

3. Chọn **Create identity**

{{< img src="images/4.ses/3.png" title="create identity" >}}

4. Ở mục **Identity details** > **Identity type** > **Domain**.
   - Bạn cần điền domain của mình vào mục **Domain**.
   - Ở mục **Verifying your domain** > **Advanced DKIM settings** > **Identity type** > **Easy DKIM**

{{< img src="images/4.ses/4.png" title="create identity" >}}

5. Chúng ta chọn **DKIM signing key length** > **RSA_2048_BIT** > **Create identity**

{{< img src="images/4.ses/5.png" title="create identity" >}}

Một email thông báo được gửi đến

{{< img src="images/4.ses/6-1.png" title="email identity done" >}}

6. Như bạn đã thấy, chúng ta đã tạo thành công

{{% notice info %}}
Action required
To verify ownership of this identity. DKIM must be configured in the domain's DNS settings using the CNAME records provided.
{{% /notice %}}

{{< img src="images/4.ses/7-1.png" title="create identity done" >}}

Cái banner nói rằng chúng ta cần cấu hình DNS record cho SES, hãy kéo xuống để thấy nội dung cần cấu hình.

{{< img src="images/4.ses/8.png" title="dns records" >}}

7. Ở mục này thì bạn có thể sử dụng **Route53** hoặc bất kì nhà cung cấp domain nào để cấu hình. Với tôi thì tôi sử dụng **matbao** để cấu hình. Có 2 thứ chúng ta cần lưu ý:

- Thứ nhất đó là 3 giá trị bạn cần thêm vào ở DNS của nhà cung cấp dịch vụ domain.

{{< img src="images/4.ses/9.png" title="dns records" >}}

- Thứ hai đó là chúng ta cần thêm DNS record để khi gửi email đến domain thì sẽ bounce qua SES endpoint, vì chúng ta sử dụng region `us-east-1` nên endpoint sẽ là `inbound-smtp.us-east-1.amazonaws.com` bạn có thể check tại [Email Receiving endpoint](https://docs.aws.amazon.com/general/latest/gr/ses.html#ses_inbound_endpoints)

{{< img src="images/4.ses/10.png" title="mx records" >}}

8. Cuối cùng, đợi vài phút để identity được verify hoặc bạn có thể làm các bước tiếp theo trong khi chờ đợi.

{{< img src="images/4.ses/11.png" title="verified" >}}
