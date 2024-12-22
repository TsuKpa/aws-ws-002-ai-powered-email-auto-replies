---
title : "Setup IAM"
date :  "`r Sys.Date()`" 
weight : 4
chapter : false
pre : " <b> 4. </b> "
---


{{< img src="images/5.iam-new/iam.png" title="iam logo" >}}

### Overview

**AWS IAM (Identity and Access Management)** and **Resource-Based Policies**

- **AWS IAM** is a fundamental service within the **AWS** ecosystem that allows you to securely manage access to your AWS resources. It provides granular control over who can access your resources and what actions they can perform.

- **Resource-based policies** are a type of access control mechanism that is attached directly to specific AWS resources, such as S3 buckets, Lambda functions, or DynamoDB tables. These policies define who can access the resource and what actions they are permitted to take.
  - **Lambda functions**: Give allow permissions to call Amazon Bedrock models, knowledge base, agents, sending emails with SES, get order information (DynamoDB) and send messages to SQS.
  - **SQS**: Allow SQS can trigger lambda function generate email content, trigger lambda function send email.
  - **Amazon Bedrock**: Allow agent to perform calling their own knowledge base, models.
  - **SES**: Give SES can calling Lambda function to extract email, putting email to S3.

### Content

4.1. [Create IAM Role for Lambda functions](4.1-create-lambda-role/)\
4.2. [Create IAM Role for SES](4.2-create-ses-role)
