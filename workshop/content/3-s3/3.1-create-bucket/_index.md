---
title : "Create S3 bucket"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 3.1. </b> "
---

1. In the **AWS Console**, search *"s3"* and choose **S3**, because we use Amazon Bedrock available in `us-east-1` so we choose region in `us-east-1`.

{{< img src="images/3.s3/1.png" title="01-s3" >}}

2. Choose **"Create Bucket"**

{{< img src="images/3.s3/1.1.png" title="choose create bucket" >}}

3. In the S3 service, we choose:

   - Choose **"us-east-1"** for low latency
   - Enter your bucket name `ai-powered-email-auto-replies` <--- we will remember this name

{{% notice info %}}
**Bucket name** is unique in global.
{{% /notice %}}

{{< img src="images/3.s3/2.png" title="enter bucket name" >}}

4. Let them default settings

{{< img src="images/3.s3/3.png" title="default settings" >}}

5. Final, scroll down and choose **"Create Bucket"**

{{< img src="images/3.s3/4.png" title="choose create bucket" >}}