---
title : "Clean up resources"
date : "`r Sys.Date()`"
weight : 11
chapter : false
pre : " <b> 11. </b> "
---

We will take the following steps to delete the resources we created in this workshop.

### Remove Amazon Bedrock

1. You need go to **Amazon Bedrock** service -> Choose agent alias -> **Delete**
{{< img src="images/11.clean/1.png" title="1" >}}

2. Type "delete" -> **Delete**
{{< img src="images/11.clean/2.png" title="2" >}}

3. Go to **Knowledge base** service -> Choose our knowledge base -> **Delete**
{{< img src="images/11.clean/3.png" title="3" >}}

4. Type "delete" -> **Delete**
{{< img src="images/11.clean/4.png" title="4" >}}

5. We also need to delete vector store database. Go to **OpenSearch** service
{{< img src="images/11.clean/5.png" title="5" >}}

6. At Serverless -> Collections -> Choose collection -> **Delete**
{{< img src="images/11.clean/6.png" title="6" >}}

7. Type "confirm" -> **Delete**
{{< img src="images/11.clean/7.png" title="7" >}}

### Remove SQS

1. Go to "SQS" service -> Choose 2 queues we just created -> **Delete**
{{< img src="images/11.clean/8.png" title="8" >}}

2. Type "confirm" -> **Delete**
{{< img src="images/11.clean/9.png" title="9" >}}

### Remove Lambda functions

1. Go to "Lambda" service -> Choose checkbox for all -> **Actions** -> **Delete**
{{< img src="images/11.clean/10.png" title="10" >}}

2. Type "confirm" -> **Delete**
{{< img src="images/11.clean/11.png" title="11" >}}

### Remove S3 bucket

1. Go to "S3" service -> Choose our bucket -> **Empty**
{{< img src="images/11.clean/12.png" title="12" >}}

2. Type "permanently delete" -> **Empty**
{{< img src="images/11.clean/13.png" title="13" >}}

3. Empty successfully! next, we need to delete bucket
{{< img src="images/11.clean/14.png" title="14" >}}

4. Choose out bucket -> **Delete**
{{< img src="images/11.clean/15.png" title="15" >}}

5. Type our bucket name -> **Delete bucket**
{{< img src="images/11.clean/16.png" title="16" >}}

### Remove SES

1. Go to "SES" service -> **Configuration** -> **Identities** -> Check all -> **Delete**
{{< img src="images/11.clean/17.png" title="17" >}}

2. Confirm to finish
{{< img src="images/11.clean/18.png" title="18" >}}

