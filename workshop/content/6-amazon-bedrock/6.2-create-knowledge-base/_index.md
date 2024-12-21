---
title : "Create knowledge base"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 6.2 </b> "
---

1. In the **Builder tools** choose the **Knowledge bases**

{{< img src="images/6.bedrock/12.png" title="bedrock-12" >}}

2. Then choose **Create knowledge base**

{{< img src="images/6.bedrock/13.png" title="bedrock-13" >}}

3. At the first step, we fill:

- Knowledge base name: `knowledge-base-ai-email-auto-response`

- IAM permissions: **Create and use a new service role**

- Data source: **Amazon S3**

{{< img src="images/6.bedrock/14a.png" title="bedrock-14" >}}

4. Choose **Next**

{{< img src="images/6.bedrock/15.png" title="bedrock-15" >}}

5. Then we need to choose our data source for the knowledge base, choose **Browse S3**

{{< img src="images/6.bedrock/16.png" title="bedrock-16" >}}

6. We will find the **faqs.txt** about our shop policies we just uploaded from [section 3](../../3-s3/3.3-upload-documents) and then click **Choose**

{{< img src="images/6.bedrock/17.png" title="bedrock-17" >}}

7. Choose **Next**
{{< img src="images/6.bedrock/18.png" title="bedrock-18" >}}

8. At this step, i choose **Titan Embeddings G1 - Text v1.2** > **Next**

{{% notice info %}}
**The new Titan Embeddings G1 – Text v1.2** can intake up to 8k tokens and outputs a vector of 1536 dimensions. The model also works in 25+ different languages. The model is optimized for text retrieval tasks but can also perform additional tasks such as semantic similarity and clustering. Titan Embeddings G1 – Text v1.2 also supports **long documents**, however, for retrieval tasks it is recommended to segment documents into logical segments (such as paragraphs or sections).
{{% /notice %}}

{{< img src="images/6.bedrock/19.png" title="bedrock-19" >}}

9. The final step is choose **Create knowledge base**
{{< img src="images/6.bedrock/21.png" title="bedrock-21" >}}
{{< img src="images/6.bedrock/20.png" title="bedrock-20" >}}

1.  The knowledge base is create successfully, you must remember the knowledge base id for setting up our lambda function, then we need to sync them before use it.

{{< img src="images/6.bedrock/21a.png" title="bedrock-22" >}}

11. Choose our **faqs.txt** document from Data source > **Sync** > Select button **Select model** at the right panel > **Claude 3 Haiku**. Then you can ask the knowledge base about our policies in the faqs document.
{{< img src="images/6.bedrock/21b.png" title="bedrock-21" >}}

12. As you can see, they can read the document and response them.
{{< img src="images/6.bedrock/21c.png" title="bedrock-21" >}}

#### About "faqs.txt" document

This file is a sample document about policies of a cat shop i generated it using Gemini. This will include some sections:

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

As you can see, this document is very humanity with format is txt, you can also using pdf, docx,... with data is your personal documents. You can read the FAQs about Amazon Bedrock [here](https://aws.amazon.com/bedrock/faqs/)
