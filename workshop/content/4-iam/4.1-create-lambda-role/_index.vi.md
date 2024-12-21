---
title : "IAM Role cho Lambda"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 4.1 </b> "
---

1. Tại màn hình **AWS Console**, tìm kiếm *"iam"* và chọn **IAM**

{{< img src="images/5.iam-new/1.png" title="1-iam" >}}

2. Kế tiếp, chúng ta cần tạo policies. Chọn **Policies** ở panel bên trái > **Create Policy**
{{< img src="images/5.iam-new/2.png" title="2-iam" >}}

3. Copy JSON policies này

{{% notice info %}}
Chú ý: Ở thuộc tính **Resource**, bạn phải để từng ARN cho mỗi resource bạn cho phép, để đơn giản thì tôi sử dụng wildcard, tôi không khuyến khích việc này
{{% /notice %}}

```json
{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket",
          "sqs:SendMessage",
          "sqs:GetQueueUrl",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
}

// Or you can use best practice for policies (Replace your account id with <account-id>)
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::ai-powered-email-auto-replies/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::ai-powered-email-auto-replies"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:us-east-1:<account-id>:log-group:/aws/lambda/ExtractEmailLambda:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage"
            ],
            "Resource": "arn:aws:sqs:us-east-1:<account-id>:generated-email-queue"
        }
    ]
}
```
Chọn editor kiểu **JSON** > paste JSON ở trên vào > **Next**

{{< img src="images/5.iam-new/3.png" title="3-iam" >}}

4. Ở mục tên policy chúng ta để `ExtractEmailFunctionPolicy` và chọn **Create policy**

{{< img src="images/5.iam-new/4.png" title="4-iam" >}}

Thành công tạo policies

{{< img src="images/5.iam-new/5.png" title="5-iam" >}}

5. Tiếp theo, chọn **Roles** > **Create role**
{{< img src="images/5.iam-new/6.png" title="6-iam" >}}

6. Ở phần use case chúng ta chọn **Lambda** > **Next**
{{< img src="images/5.iam-new/7.png" title="7-iam" >}}

7. Chọn `ExtractEmailFunctionPolicy` đã tạo > **Next**
{{< img src="images/5.iam-new/8.png" title="8-iam" >}}

8. Điền tên role `ExtractEmailFunctionRole` 
{{< img src="images/5.iam-new/9.png" title="9-iam" >}}

9. Chọn **Create role**

{{< img src="images/5.iam-new/10.png" title="10-iam" >}}

10. Thành công tạo ExtractEmailLambdaRole

{{< img src="images/5.iam-new/11.png" title="11-iam" >}}

### Ok, bây giờ bạn hãy tạo 2 role còn lại

Bạn hãy lập lại các bước ở trên để tạo 2 role còn lại với cấu hình sau đây

1. Generate email lambda function role

| Configuration | Value                         |
| ------------- | ----------------------------- |
| role          | `GenerateEmailFunctionRole`   |
| policy        | `GenerateEmailFunctionPolicy` |

{{% notice info %}}
NOTE: In real life, the **Resource** property, you must change the specified ARN you want to allow, for simple i am using wildcard for all components in that service, this is not recommend.
{{% /notice %}}

```json
{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect": "Allow",
        "Action": [
          "bedrock:InvokeModel",
          "bedrock:ListKnowledgeBases", 
          "bedrock:GetKnowledgeBase",
          "bedrock:Retrieve",
          "bedrock:RetrieveAndGenerate",
          "bedrock:ListAgents",
          "bedrock:GetAgent",
          "bedrock:InvokeAgent"
        ],
        "Resource": [
          "arn:aws:bedrock:us-east-1::foundation-model/*",
          "arn:aws:bedrock:us-east-1:<account-id>:knowledge-base/*",
          "arn:aws:bedrock:us-east-1:<account-id>:agent/*",
          "arn:aws:bedrock:us-east-1:<account-id>:agent-alias/*"
        ]
      },
      {
            "Effect": "Allow",
            "Action": [
                "sqs:SendMessage",
                "sqs:ReceiveMessage",
                "sqs:GetQueueUrl",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": "arn:aws:sqs:us-east-1:<account-id>:sqs-send-email-to-customer-queue"
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:Scan", 
                "dynamodb:Query",
                "dynamodb:GetItem"
            ],
            "Resource": "arn:aws:dynamodb:us-east-1:<account-id>:table/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:us-east-1:<account-id>:log-group:/aws/lambda/GenerateEmailLambda:*"
        }
    ]
  }
```

2. Send email lambda function role

| Configuration | Value                     |
| ------------- | ------------------------- |
| role          | `SendEmailFunctionRole`   |
| policy        | `SendEmailFunctionPolicy` |

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow", 
            "Action": [
                "sqs:SendMessage",
                "sqs:ReceiveMessage",
                "sqs:GetQueueUrl",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": "arn:aws:sqs:us-east-1:<account-id>:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "arn:aws:ses:us-east-1:<account-id>:identity/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::ai-powered-email-auto-replies"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::ai-powered-email-auto-replies/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:us-east-1:<account-id>:log-group:/aws/lambda/GenerateEmailLambda:*"
        }
    ]
}
```

Sau khi tạo xong thì chúng ta sẽ qua phần kế tiếp, role này sẽ được sử dụng ở Lambda function.