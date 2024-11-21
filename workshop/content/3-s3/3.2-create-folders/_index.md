---
title : "Create folders"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 3.2. </b> "
---

In this section, we need 3 folders to save our data:

- `received-email`: This folder will save raw email received from SES
- `documents`: This folder will store `faqs.txt`, this file is for training our AI knowledge base about shop policies, payment methods...
- `generated-email`: This folder save generated email content after we send email reply to the customer

1. After created S3 bucket we choose our bucket `"ai-powered-email-auto-replies"`

{{< img src="images/3.s3/5.png" title="choose our bucket" >}}

2. Choose **"Create folder"**

{{< img src="images/3.s3/6.png" title="Create folder" >}}

3. Enter the first folder `received-email` into **Folder name** and choose **"Create folder"**

{{< img src="images/3.s3/7-1.png" title="create first folder" >}}

4. Repeat **Step 3** to create 2 remaining folders `documents`, `generated-email`.

{{< img src="images/3.s3/8-1.png" title="create remaining folders" >}}
