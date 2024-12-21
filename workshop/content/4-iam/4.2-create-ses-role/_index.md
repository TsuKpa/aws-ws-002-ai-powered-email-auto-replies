---
title : "IAM Role for SES"
date :  "`r Sys.Date()`" 
weight : 4
chapter : false
pre : " <b> 4.2 </b> "
---

### Ok, Let's create SES remaining policy

Please repeat from step 4.1.1 -> 4.1.4 to create SES policy, we will create SES role in the ExtractEmailLambda section

| Configuration | Value                    |
| ------------- | ------------------------ |
| policy        | `SESSaveEmailToS3Policy` |

```json
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Action": [
    "s3:PutObject"
   ],
   "Resource": [
    "arn:aws:s3:::ai-powered-email-auto-replies/*"
   ]
  }
 ]
}
```