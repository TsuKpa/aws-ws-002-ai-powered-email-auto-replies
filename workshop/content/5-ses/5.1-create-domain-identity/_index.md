---
title : "Create Domain identity"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

1. In the **AWS Console**, search *"ses"* and choose **Amazon Simple Email Service**

{{< img src="images/4.ses/1.png" title="ses" >}}

2. At the left panel, choose **"Identities"**

{{< img src="images/4.ses/2.png" title="identities" >}}

3. Choose **Create identity**

{{< img src="images/4.ses/3.png" title="create identity" >}}

4. Then at the **Identity details** > **Identity type** > **Domain**.
   - Then you will fill your custom domain at the field **Domain**, at this case i used my own domain.
   - At the **Verifying your domain** > **Advanced DKIM settings** > **Identity type** > **Easy DKIM**

{{< img src="images/4.ses/4.png" title="create identity" >}}

5. We choose **DKIM signing key length** > **RSA_2048_BIT** for security. Then click **Create identity**

{{< img src="images/4.ses/5.png" title="create identity" >}}

An email notification from AWS

{{< img src="images/4.ses/6-1.png" title="email identity done" >}}

6. As you can see, we just created an identity

{{% notice info %}}
Action required
To verify ownership of this identity. DKIM must be configured in the domain's DNS settings using the CNAME records provided.
{{% /notice %}}

{{< img src="images/4.ses/7-1.png" title="create identity done" >}}

A banner that tell me to config DNS record to AWS SES. Let scroll down to see some configuration.

{{< img src="images/4.ses/8.png" title="dns records" >}}

7. At this section, you can use **Route53** or any Domain provider to config your DNS. In my case, i used **matbao** to config. There are 2 things you need to focus:

- The first thing is 3 records as the image above you need to insert them in DNS panel of you domain provider.

{{< img src="images/4.ses/9.png" title="dns records" >}}

- The second thing is pointing from domain DNS email record to SES service endpoint, because we focus on region `us-east-1` so the endpoint will be `inbound-smtp.us-east-1.amazonaws.com` you can check this at [Email Receiving endpoint](https://docs.aws.amazon.com/general/latest/gr/ses.html#ses_inbound_endpoints)

{{< img src="images/4.ses/10.png" title="mx records" >}}

8. Final, let wait a bit and you can see your domain identity is verified

{{< img src="images/4.ses/11.png" title="verified" >}}
