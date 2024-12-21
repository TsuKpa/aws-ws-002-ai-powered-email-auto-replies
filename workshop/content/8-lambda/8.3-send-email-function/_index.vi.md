---
title : "Tạo Send Email Function"
date :  "`r Sys.Date()`" 
weight : 3
chapter : false
pre : " <b> 8.3 </b> "
---

Đây là function cuối cùng, với các nhiệm vụ:

- Nhận tin nhắn SQS và gửi phản hồi cho người dùng
- Lưu phản hồi đó vào S3.

#### Tại sao tôi cần function này?

- Bởi vì tôi muốn lưu việc gửi phản hồi email, debug agent email của tôi dựa trên email phản hồi.
- Dễ dàng hơn để debug

#### Các bước thực hiện

Bạn có thể xem lại mục 8.1, 8.2 để upload source code

Bạn có thể download tại [index.zip](https://d9akteslg4v3w.cloudfront.net/workshops/002/send/index.zip) hoặc bạn có thể build tại đây [tại đây](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies/tree/master/resource/lambda/send-email). Sau khi đã có thì chọn **Code** > **Upload from** > **.zip file**

Tiếp theo là thêm biến môi trường

{{< img src="images/8.lambda/14.png" title="lambda14" >}}

Chúng ta sẽ có 2 giá trị

| Key            | Value                           | Description                                              |
| -------------- | ------------------------------- | -------------------------------------------------------- |
| `SOURCE_EMAIL` | support@YOUR_DOMAIN             | Đây là email mà bạn muốn trả lời (sender) |
| `BUCKET_NAME`  | `ai-powered-email-auto-replies` | S3 bucket để lưu nội dung phản hồi                   |

Chọn **Save**

{{< img src="images/8.lambda/15.png" title="lambda15" >}}

Cập nhật biến môi trường thành công

{{< img src="images/8.lambda/16.png" title="lambda16" >}}

#### Thông tin chi tiết

| Configuration | Value                   | Description                                                                |
| ------------- | ----------------------- | -------------------------------------------------------------------------- |
| function_name | `SendEmailLambda`       | The unique name identifier for the Lambda function                         |
| role          | `SendEmailFunctionRole` | IAM role that defines the permissions and access policies for the function |
| runtime       | nodejs20.x              | The execution environment and version for the Lambda function (Node.js 20) |
| handler       | index.handler           | The entry point for the function                                           |
| memory_size   | 128                     | Amount of memory allocated to the function in MB (128MB)                   |
| timeout       | 30                      | Maximum execution time allowed for the function in seconds                 |

1. Send email via SES

```ts
const data: MessageData = JSON.parse(sqsData.body);
const params: SendEmailCommandInput = {
    Destination: {
        ToAddresses: [data.sender],
    },
    Message: {
        Body: {
            Text: { Data: data.text },
        },
        Subject: { Data: data.subject },
    },
    Source: env.sourceEmail,
};
const command = new SendEmailCommand(params);
await ses.send(command);
```

2. Save response to S3

```ts
await s3.send(
    new PutObjectCommand({
        Bucket: env.bucketName,
        Key: `generated-email/${content.key}.json`,
        Body: content.data,
        ContentType: 'application/json'
    })
);
```

Full source code
```ts
import { SESClient, SendEmailCommand, SendEmailCommandInput } from "@aws-sdk/client-ses";
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { Handler, SQSEvent } from 'aws-lambda';
import { Logger } from '@aws-lambda-powertools/logger';

const logger = new Logger();

require('dotenv').config();

type MessageData = {
    messageId: string;
    sender: string;
    subject: string;
    text: string;
};

type S3Data = {
    key: string;
    data: string;
};

const env = {
    sourceEmail: process.env.SOURCE_EMAIL || "",
    bucketName: process.env.BUCKET_NAME || ""
}

const ses = new SESClient();
const s3 = new S3Client();

export const handler: Handler = async (event: SQSEvent): Promise<void> => {
    try {
        const content = await sendEmailToCustomer(event);
        if (content) {
            await saveResponseToS3(content);
        }
    }
    catch (error) {
        logger.error(error as string);
    }
};

const sendEmailToCustomer = async (event: SQSEvent): Promise<S3Data | null> => {
    // logger.info('Sending email to customer', event.Records.toString());
    const sqsData = event.Records[0];
    // logger.info('Body', sqsData.body);
    if (sqsData) {
        const data: MessageData = JSON.parse(sqsData.body);
        const params: SendEmailCommandInput = {
            Destination: {
                ToAddresses: [data.sender],
            },
            Message: {
                Body: {
                    Text: { Data: data.text },
                },
                Subject: { Data: data.subject },
            },
            Source: env.sourceEmail,
        };
        const command = new SendEmailCommand(params);
        await ses.send(command);
        return { key: data.messageId, data: JSON.stringify(params) };
    }
    return null;
}

const saveResponseToS3 = async (content: S3Data) => {
    // logger.info('Saving response to S3', content);
    await s3.send(
        new PutObjectCommand({
            Bucket: env.bucketName,
            Key: `generated-email/${content.key}.json`,
            Body: content.data,
            ContentType: 'application/json'
        })
    );
}
```