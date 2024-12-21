---
title : "Create Send Email Function"
date :  "`r Sys.Date()`" 
weight : 3
chapter : false
pre : " <b> 8.3 </b> "
---

This is the final function, with missions: 

- Received SQS message and sending response to user
- Save that response to S3.

#### Why i need this function?

- Because i want to save sending email response for debugging our email agent based on response email.
- Easier for debug

#### Let's create the lambda function

You can review step 8.1, 8.2 to upload source code

You can download it [index.zip](https://d9akteslg4v3w.cloudfront.net/workshops/002/send/index.zip) or you can build them with my github repository [here](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies/tree/master/resource/lambda/send-email). After got that file, you need to upload it to lambda **Code** > **Upload from** > **.zip file**

Next, we need to config environment variable for our function to interact with other service

{{< img src="images/8.lambda/14.png" title="lambda14" >}}

We have 2 variables

| Key            | Value                           | Description                                              |
| -------------- | ------------------------------- | -------------------------------------------------------- |
| `SOURCE_EMAIL` | support@YOUR_DOMAIN             | This is the support email you want to reply to your user |
| `BUCKET_NAME`  | `ai-powered-email-auto-replies` | This bucket for putting email response                   |

Click **Save**

{{< img src="images/8.lambda/15.png" title="lambda15" >}}

Update environment variables successfully

{{< img src="images/8.lambda/16.png" title="lambda16" >}}

#### Details about our function

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