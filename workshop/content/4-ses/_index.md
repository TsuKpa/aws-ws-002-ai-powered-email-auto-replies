---
title : "Setup SES"
date : "`r Sys.Date()`"
weight : 4
chapter : false
pre : " <b> 4. </b> "
---

{{< img src="images/4.cloudfront/cloudfront.png" title="cloudfront logo" >}}

### Overview

**Amazon CloudFront** is a web service that speeds up distribution of your static and dynamic web content, such as .html, .css, .js, and image files, to your users.

**CloudFront** delivers your content through a worldwide network of data centers called edge locations. When a user requests content that you're serving with **CloudFront**, the request is routed to the edge location that provides the lowest latency (time delay), so that content is delivered with the best possible performance.

You can use **Cloudfront** for redirect HTTP to HTTPS for **Static Web Hosting S3**, also implement **WAF** for more security.

### Content

1. In the **AWS Console**, search *"cloudfront"* and choose **Cloudfront**

{{< img src="images/4.cloudfront/01-cloudfront.png" title="01-cloudfront" >}}

2. Choose **"Create a CloudFront distribution"**

{{< img src="images/4.cloudfront/02-cloudfront.png" title="02-cloudfront" >}}

3. At the **Origin domain** we choose our created S3 bucket

{{< img src="images/4.cloudfront/03-cloudfront.png" title="04-cloudfront" >}}

4. At the **Origin access** we choose:
   - Choose **"Legacy access identities"**
   - Choose **"Yes, update the bucket policy"**
   - Choose **"Create new OAI"**

{{< img src="images/4.cloudfront/04-cloudfront.png" title="04-cloudfront" >}}

5. Choose **"Create"**

{{< img src="images/4.cloudfront/05-cloudfront.png" title="05-cloudfront" >}}

6. At **Default Cache Behavior** > **"View"** Choose **"Redirect HTTP to HTTPS"**

{{< img src="images/4.cloudfront/06-cloudfront.png" title="06-cloudfront" >}}

7. Choose default

{{< img src="images/4.cloudfront/07-cloudfront.png" title="07-cloudfront" >}}

8. At **"Web Application Firewall"** we choose **"Do not enable security protection"**, and at the **"Settings"** we choose **"Use North America, Europe, Asia, Middle East, and Africa"**

{{< img src="images/4.cloudfront/08-cloudfront.png" title="08-cloudfront" >}}

9. Final, scroll down and choose **"Create distribution"**

{{< img src="images/4.cloudfront/09-cloudfront.png" title="09-cloudfront" >}}
