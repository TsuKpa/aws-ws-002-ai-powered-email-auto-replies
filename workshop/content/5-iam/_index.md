---
title : "Setup IAM"
date :  "`r Sys.Date()`" 
weight : 5 
chapter : false
pre : " <b> 5. </b> "
---


{{< img src="images/5.iam/iam.png" title="iam logo" >}}

### Overview

**AWS Identity and Access Management (IAM)** is a web service that helps you securely control access to **AWS** resources. With IAM, you can manage permissions that control which **AWS** resources users can access.

You use **IAM** to control who is authenticated (signed in) and authorized (has permissions) to use resources. IAM provides the infrastructure necessary to control authentication and authorization for your **AWS** accounts.

**AWS Security Token Service (AWS STS)** use to create and provide trusted users with temporary security credentials that can control access to your AWS resources.

### Content

5.1. [Create Identity Provider (OIDC)](5.1-create-oidc/)\
5.2. [Create IAM Role](5.2-create-iam-role/)