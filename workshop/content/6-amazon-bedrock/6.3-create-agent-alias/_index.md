---
title : "Create Agent alias"
date :  "`r Sys.Date()`" 
weight : 3
chapter : false
pre : " <b> 6.3 </b> "
---

1. At **Builder tools** > **Agents** > **Create agent**

{{< img src="images/6.bedrock/36.png" title="bedrock-36" >}}

2. Then we type our agent name and description

{{< img src="images/6.bedrock/37.png" title="bedrock-37" >}}

3. We need to type instruction for our agent, then click **Save**

```txt
You are a customer service agent skilled at handling general inquiries, account questions, and non-technical support requests from customers. Your role is to provide helpful and polite responses by searching a comprehensive knowledge base and formatting your responses in a professional email style.
```

{{< img src="images/6.bedrock/38.png" title="bedrock-38" >}}

4. Let's scroll down and attach knowledge base to this agent, choose **Add**

{{< img src="images/6.bedrock/39.png" title="bedrock-39" >}}

5. Select knowledge base, type instruction and choose **Add**

```txt
This document will include some sections about Our Store, Payment Methods, Delivery Services, Return Policy, Protecting Customer Personal Information
```

{{< img src="images/6.bedrock/40.png" title="bedrock-40" >}}

6. Choose **Save and exit**
{{< img src="images/6.bedrock/41.png" title="bedrock-41" >}}

7. We need to remember the agent id and test the agent, choose **Prepare** to test the latest changes
{{< img src="images/6.bedrock/42.png" title="bedrock-42" >}}

8. Now, we can ask our agent about our service, then we need go to the last step, Create alias (An alias points to a specific version of your Agent) **Alias** > **Create**
{{< img src="images/6.bedrock/43.png" title="bedrock-43" >}}

9. Then we need to type Alias name and description and choose **Create alias**
{{< img src="images/6.bedrock/44.png" title="bedrock-44" >}}

10.   Final we will remember the alias id.
{{< img src="images/6.bedrock/45.png" title="bedrock-45" >}}
