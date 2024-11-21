---
title : "Create IAM Role"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 5.2 </b> "
---

1. In the **Identity Providers** choose the Provider we just created

{{< img src="images/5.iam/4-iam.png" title="4-iam" >}}

2. Choose **"Assign role"**

{{< img src="images/5.iam/5-iam.png" title="5-iam" >}}

3. Choose **"Create a new role"** -> **"Next"**

{{< img src="images/5.iam/6-iam.png" title="6-iam" >}}

4. At the **Step 1**
   - At **Trusted Entity type** we choose **"Web identity"**
   - At Web Identity:
     - Choose **Identity Provider** `https://token.actions.githubusercontent.com`
     - Choose **Audience** `sts.amazonaws.com`
     - **Github Organization**: Fill your github username (This name is case sensitive)
     - Click **Next**

{{< img src="images/5.iam/7-iam.png" title="7-iam" >}}

5. At the **Step 2** is **AWS Managed Policy** but we will create inline policy so we choose **"Next"**

{{< img src="images/5.iam/8-iam.png" title="8-iam" >}}

6. At the **Step 3** you will fill your role name like images and remember that role for later

{{< img src="images/5.iam/8.1-iam.png" title="8.1-iam" >}}

7. Click **"Create role"**

{{< img src="images/5.iam/9-iam.png" title="9-iam" >}}

8. At the left menu choose **"Roles"** -> Search your created role -> Choose that role

{{< img src="images/5.iam/10-iam.png" title="10-iam" >}}

9. At the **Permission Policies** -> Choose **"Add permissions"** -> **Create inline policy**

{{< img src="images/5.iam/11-iam.png" title="11-iam" >}}

10. At **Step 1** choose **JSON** and copy paste the following policy (Remember change these ID for your case):

```json
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Sid": "SyncToBucket",
   "Effect": "Allow",
   "Action": [
    "s3:PutObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:DeleteObject"
   ],
   "Resource": [
    "arn:aws:s3:::YOUR_BUCKET_NAME/*",
    "arn:aws:s3:::YOUR_BUCKET_NAME"
   ]
  },
  {
   "Sid": "FlushCache",
   "Effect": "Allow",
   "Action": "cloudfront:CreateInvalidation",
   "Resource": "arn:aws:cloudfront::YOUR_ACCOUNT_ID:distribution/YOUR_CLOUDFRONT_ID"
  }
 ]
}
```

{{< img src="images/5.iam/12-iam.png" title="12-iam" >}}

Then click **"Next"** -> **"Save Changes"**
