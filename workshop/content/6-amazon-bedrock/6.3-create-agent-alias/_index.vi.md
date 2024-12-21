---
title : "Tạo Agent alias"
date :  "`r Sys.Date()`" 
weight : 3
chapter : false
pre : " <b> 6.3 </b> "
---

1. Ở mục **Builder tools** > **Agents** > **Create agent**

{{< img src="images/6.bedrock/36.png" title="bedrock-36" >}}

2. Nhập tên và mô tả Agent

{{< img src="images/6.bedrock/37.png" title="bedrock-37" >}}

3. Chúng ta cần nhập instruction cho agent, và chọn **Save**

```txt
You are a customer service agent skilled at handling general inquiries, account questions, and non-technical support requests from customers. Your role is to provide helpful and polite responses by searching a comprehensive knowledge base and formatting your responses in a professional email style.
```

{{< img src="images/6.bedrock/38.png" title="bedrock-38" >}}

4. Hãy kéo xuống và thêm knowledge base, chọn **Add**

{{< img src="images/6.bedrock/39.png" title="bedrock-39" >}}

5. Chọn knowledge base, thêm instuction và chọn **Add**

```txt
This document will include some sections about Our Store, Payment Methods, Delivery Services, Return Policy, Protecting Customer Personal Information
```

{{< img src="images/6.bedrock/40.png" title="bedrock-40" >}}

6. Chọn **Save and exit**
{{< img src="images/6.bedrock/41.png" title="bedrock-41" >}}

7. Chúng ta cần nhớ agent id và kiểm tra xem nó có hoạt động hay không, chọn **Prepare** để chuẩn bị cho dữ liệu mới nhất
{{< img src="images/6.bedrock/42.png" title="bedrock-42" >}}

8. Bây giờ, chúng ta đã có thể hỏi về dịch vụ có trong tài liệu. Cuối cùng, Tạo alias (Alias dùng để trỏ đến một phiên bản của agent) **Alias** > **Create**
{{< img src="images/6.bedrock/43.png" title="bedrock-43" >}}

9. Nhập Alias name và mô tả > **Create alias**
{{< img src="images/6.bedrock/44.png" title="bedrock-44" >}}

10. Cuối cùng là nhớ alias id
{{< img src="images/6.bedrock/45.png" title="bedrock-45" >}}
