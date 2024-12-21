---
title : "Kiểm tra kết quả"
date : "`r Sys.Date()`"
weight : 10
chapter : false
pre : " <b> 10. </b> "
---

1. Để test thì chúng ta cần vào mail để gửi email mẫu đến server mail chúng ta đã cài đặt. Ở đây thì tôi sử dụng gmail và gửi nội dung mẫu như bên dưới

```txt
Do you accept payment methods with credit cards?
```

{{< img src="images/10.result/1.png" title="1" >}}

2. Chúng ta sẽ vào S3 để kiểm tra xem đã lưu được hay chưa, ok đã có.

{{< img src="images/10.result/2.png" title="2" >}}

3. Tiếp theo là ExtractEmailLambda có hoạt động hay không, chúng ta sẽ vào Cloudwatch để xem

{{< img src="images/10.result/3.png" title="3" >}}

4. Phần GenerateEmailLambda cũng vậy

{{< img src="images/10.result/4.png" title="4" >}}

5. Và hàm cuối cùng là SendEmailLambda

{{< img src="images/10.result/5.png" title="5" >}}

6. Ngon mọi thứ đã hoạt động :D. Và kết quả đã trả về email cho tôi

{{< img src="images/10.result/6.png" title="6" >}}

7. Giờ thì thử hỏi nội dung có chứa trong database

{{< img src="images/10.result/7.png" title="7" >}}

8. Hỏi về policies trong tài liệu

{{< img src="images/10.result/8.png" title="8" >}}

Xong, Hy vọng qua workshop này bạn có 1 cái nhìn cơ bản nhất về ứng dụng của Generative AI và serverless infrastructure. Nếu bạn thích workshop này thì ngại gì cho mình 1 like ở github hoặc linkedin. Nếu có thắc mắc, bạn vui lòng comment để được mình hỗ trợ nhé <3