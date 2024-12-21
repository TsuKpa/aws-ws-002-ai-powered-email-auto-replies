---
title : "IAM Role cho SES"
date :  "`r Sys.Date()`" 
weight : 4
chapter : false
pre : " <b> 4.2 </b> "
---

### Ok, Chỉ còn 1 IAM policies nữa cho SES

Bạn vui lòng lặp lại từ bước 4.1.1 -> 4.1.4 để tạo SES policies, chúng ta sẽ tạo role ở phần ExtractEmailLambda

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