---
title : "Tạo knowledge base"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 6.2 </b> "
---

1. Trong mục **Builder tools** chọn **Knowledge bases**

{{< img src="images/6.bedrock/12.png" title="bedrock-12" >}}

2. Sau đó chọn **Create knowledge base**

{{< img src="images/6.bedrock/13.png" title="bedrock-13" >}}

3. Ở bước đầu tiên chúng ta điền:

- Knowledge base name: `knowledge-base-ai-email-auto-response`

- IAM permissions: **Create and use a new service role**

- Data source: **Amazon S3**

{{< img src="images/6.bedrock/14a.png" title="bedrock-14" >}}

4. Chọn **Next**

{{< img src="images/6.bedrock/15.png" title="bedrock-15" >}}

5. Tiếp theo chúng ta cần chọn data source, chọn **Browse S3**

{{< img src="images/6.bedrock/16.png" title="bedrock-16" >}}

6. Chúng ta sẽ tìm file đã upload **faqs.txt** chúng ta đã upload ở [section 3](../../3-s3/3.3-upload-documents) và chọn **Choose**

{{< img src="images/6.bedrock/17.png" title="bedrock-17" >}}

7. Chọn **Next**
{{< img src="images/6.bedrock/18.png" title="bedrock-18" >}}

8. Ở bước này, tôi chọn **Titan Embeddings G1 - Text v1.2** > **Next**

{{% notice info %}}
**The new Titan Embeddings G1 – Text v1.2** can intake up to 8k tokens and outputs a vector of 1536 dimensions. The model also works in 25+ different languages. The model is optimized for text retrieval tasks but can also perform additional tasks such as semantic similarity and clustering. Titan Embeddings G1 – Text v1.2 also supports **long documents**, however, for retrieval tasks it is recommended to segment documents into logical segments (such as paragraphs or sections).
{{% /notice %}}

{{< img src="images/6.bedrock/19.png" title="bedrock-19" >}}

9. Tiếp theo là chọn **Create knowledge base**
{{< img src="images/6.bedrock/21.png" title="bedrock-21" >}}
{{< img src="images/6.bedrock/20.png" title="bedrock-20" >}}

10.  Knowledge base đã được tạo thành công, bạn cần ghi nhớ hoặc sao chép id này. Trước khi sử dụng thì chúng ta cần sync nó trước.

{{< img src="images/6.bedrock/21a.png" title="bedrock-22" >}}

11.  Chọn tài liệu **faqs.txt** từ Data source > **Sync** > Chọn nút **Select model** bên phải > **Claude 3 Haiku**. Và bạn có thể hỏi chúng về tài liệu đã upload lên.

{{< img src="images/6.bedrock/21b.png" title="bedrock-21" >}}

12.  Như bạn đã thấy thì nó có thể đọc tài liệu và trả lời lại cho chúng ta.
{{< img src="images/6.bedrock/21c.png" title="bedrock-21" >}}

#### Về "faqs.txt" document

Về tài liệu thì mình sử dụng tiếng anh thay vì tiếng việt, nội dung đơn giản là về policies của một shop bán dịch vụ chăm sóc mèo.

1. **About Our Store**
	- **What kind of products do you sell**? We specialize in high-quality cat food, toys, accessories, and grooming supplies.
	- **Do you offer grooming services**? Yes, we offer a variety of grooming services, including bathing, brushing, nail trimming, and ear cleaning.
	- **Do you have a loyalty program**? Absolutely! We offer a rewards program for our loyal customers.
Cat Food
    - ...

2. **Additional Questions**

    - **Payment Methods: Do you accept [payment methods, e.g., credit cards, cash, mobile payments]**?
	    - We accept the following payment methods:
            - Credit Cards: Visa, Mastercard, American Express, Discover Card, PayPal
            - Debit Cards: Visa, Mastercard, American Express, Discover Card, PayPal
            - Cash: We accept both local and foreign currency.
            - Mobile Payments: We accept popular mobile payment platforms such as Google Pay, Apple Pay, Samsung Pay, MoMo, VCB, ACB, TPB.
    - **Delivery Services: Do you offer delivery services?**
	    - Yes, we pride ourselves on providing our customers with the quickest shipping options available.
	    - We guarantee speedy delivery times, often within [24-48 hours] for local orders and [3-5 business days] for international orders.
	    - You'll receive a tracking number as soon as your order ships, allowing you to monitor its progress in real-time.
3. **Return Policy**
4. **Protecting Your Personal Information**

Như bạn đã thấy thì tài liệu có định dạng là txt, bạn có thể sử dụng pdf, docx,... với data có thể là dữ liệu nội bộ hay riêng tư. Bạn có thể đọc FAQs về Amazon Bedrock [tại đây](https://aws.amazon.com/bedrock/faqs/)
