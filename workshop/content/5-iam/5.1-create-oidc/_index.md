---
title : "Create Identity Provider (OIDC)"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 5.1 </b> "
---

1. In the **AWS Console**, search *"iam"* and choose **IAM**

{{< img src="images/5.iam/1-iam.png" title="1-iam" >}}

2. In the **Access Management** choose **Identity Providers**

{{< img src="images/5.iam/2-iam.png" title="2-iam" >}}

3. In the **Identity Providers** fill the input with following:
    - **Provider type**: Choose **"OpenID Connect"**
    - **Provider URL**: `https://token.actions.githubusercontent.com`
    - **Audience**: `sts.amazonaws.com`
    - Click **"Add Provider"**

{{< img src="images/5.iam/3-iam.png" title="3-iam" >}}

4. In the **Access Management** choose **Identity Providers**

{{< img src="images/5.iam/5-iam.png" title="5-iam" >}}
