---
title : "Clean up resources"
date : "`r Sys.Date()`"
weight : 11
chapter : false
pre : " <b> 11. </b> "
---

We will take the following steps to delete the resources we created in this workshop.

### Remove Cloudfront

1. You need go to **Cloudfront** service -> Choose your Cloudfront -> **Disable**
{{< img src="images/6.clean/cloudfront/03-clean.png" title="03-clean" >}}

2. Wait about 10 minutes then you can choose and delete it
{{< img src="images/6.clean/cloudfront/04-clean.png" title="04-clean" >}}

3. Delete it
{{< img src="images/6.clean/cloudfront/11-clean.png" title="11-clean" >}}

### Remove S3

1. We need to empty bucket before delete it, select all object and choose **"Delete"**
{{< img src="images/6.clean/s3/05-clean.png" title="05-clean" >}}

2. Type confirm text and click **"Delete objects"**
{{< img src="images/6.clean/s3/06-clean.png" title="06-clean" >}}

3. Click **"Close"**
{{< img src="images/6.clean/s3/07-clean.png" title="07-clean" >}}

4. After that our bucket is empty, then we go back
{{< img src="images/6.clean/s3/08-clean.png" title="08-clean" >}}

5. Choose our bucket again
{{< img src="images/6.clean/s3/09-clean.png" title="09-clean" >}}

6. Confirm to delete
{{< img src="images/6.clean/s3/10-clean.png" title="10-clean" >}}

### Remove IAM

1. Delete our Role by choose the role and click **"Delete"**
{{< img src="images/6.clean/iam/12-clean.png" title="12-clean" >}}

2. Delete Identity Provider by choose it and click **"Delete"**
{{< img src="images/6.clean/iam/14-clean.png" title="14-clean" >}}

### Delete Github Repository

1. Delete environment secrets
{{< img src="images/6.clean/github/16-clean.png" title="16-clean" >}}

2. Click **"I understand, delete this environment"**
{{< img src="images/6.clean/github/17-clean.png" title="17-clean" >}}

3. Delete repository
{{< img src="images/6.clean/github/19-clean.png" title="19-clean" >}}
