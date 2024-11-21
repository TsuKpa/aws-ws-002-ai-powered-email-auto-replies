---
title : "Setup Amazon Bedrock"
date : "`r Sys.Date()`"
weight : 6
chapter : false
pre : " <b> 6. </b> "
---

#### Preparation

First of all, you need to download source code NextJS in this workshop at this [link](https://github.com/TsuKpa/001-deploy-static-site-to-s3) at the folder `next-app`, you will move it to other folder and push to your repository in the Github. Then you can go next.

#### Content

1. In your repository, click **"Settings"** -> At "Secrets and variables" choose **Actions** -> **"Manage Environment Secrets"**

{{< img src="images/6.github/02-github.png" title="02-github" >}}

2. Click **"New Environment"** if you don't have any

{{< img src="images/6.github/03-github.png" title="03-github" >}}

3. Enter your Environment name and click **"Configure environment"**

{{< img src="images/6.github/04-github.png" title="04-github" >}}

4. After that click **"Add environment secret"**

{{< img src="images/6.github/05-github.png" title="05-github" >}}

5. You need to add all of your secrets, in this workshop we have

   - `AWS_ACCOUNT_ID` is in the top right in the AWS Console
   - `AWS_REGION` ex: `ap-southeast-1`
   - `AWS_S3_ASSUME_ROLE` The role name we created before
   - `BUCKET_NAME`: The bucket name we created
   - `CF_DISTRIBUTION_ID`: The Cloudfront ID we created \
  ex: **arn:aws:cloudfront::<YOUR_ACCOUNT_ID>:distribution/<CF_DISTRIBUTION_ID`>** <--- the cloudfront id here

{{< img src="images/6.github/06-github.png" title="06-github" >}}

6. Result of all secrets we added

{{< img src="images/6.github/07-github.png" title="07-github" >}}
