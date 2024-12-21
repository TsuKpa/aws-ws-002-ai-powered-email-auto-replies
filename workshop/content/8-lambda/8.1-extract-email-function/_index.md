---
title : "Create Extract Email Function"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 8.1 </b> "
---

This is the first function, with missions: 

- Extract email content from MIME type to JSON data
- Send that data to SQS.

#### Why i need this function?

Because many reasons:

- I want to save money when calling Amazon Bedrock and lambda function in **Generate email function** (If a email with wrong data, we can parse them to our formatted data first before calling AI agent, reduce the tokens send to LLM model)
- Easier for debugging
- In real life, maybe some hater will attack this endpoint with spamming, so we can put a process function here.

#### Let's create the lambda function

1. In the **AWS Console**, search *"lambda"* and choose **Lambda**

{{< img src="images/8.lambda/1.png" title="lambda1" >}}

2. Choose **Create function**

{{< img src="images/8.lambda/2.png" title="lambda2" >}}

3. In the **AWS Console**, choose **Author from scratch**, Function name is `ExtractEmailLambda`, because i our code is use nodejs so we choose **Nodejs 22.x**. Then we choose existing role `ExtractEmailFunctionRole` then click **Create function**

{{< img src="images/8.lambda/3.png" title="lambda3" >}}

4. Next, we need to upload our source code to this function, you can download it [index.zip](https://d9akteslg4v3w.cloudfront.net/workshops/002/extract/index.zip) or you can build them with my github repository [here](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies/tree/master/resource/lambda/extract-email). After got that file, you need to upload it to lambda **Code** > **Upload from** > **.zip file**

{{< img src="images/8.lambda/4.png" title="lambda4" >}}

5. Click **Save** to upload it

{{< img src="images/8.lambda/5.png" title="lambda5" >}}

6. Upload successful
{{< img src="images/8.lambda/6.png" title="lambda6" >}}

7. Next, we need to config environment variable for our function to interact with other service

{{< img src="images/8.lambda/7.png" title="lambda7" >}}

8. We have 2 variables

| Key           | Value                              | Description                                                                                                                                           |
| ------------- | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `QUEUE_NAME`  | `sqs-generate-email-content-queue` | This is the queue name we will send message (email content) to generate response                                                                      |
| `BUCKET_NAME` | `ai-powered-email-auto-replies`    | This bucket for getting email content, because SES not emit email content, it just emit the **messageId** (the key of the email object in our bucket) |

Click **Save**

{{< img src="images/8.lambda/8.png" title="lambda8" >}}

9. Update environment variables successfully

{{< img src="images/8.lambda/9.png" title="lambda9" >}}

#### Details about our function

| Configuration | Value                      | Description                                                                |
| ------------- | -------------------------- | -------------------------------------------------------------------------- |
| function_name | `ExtractEmailLambda`       | The unique name identifier for the Lambda function                         |
| role          | `ExtractEmailFunctionRole` | IAM role that defines the permissions and access policies for the function |
| runtime       | nodejs20.x                 | The execution environment and version for the Lambda function (Node.js 20) |
| handler       | index.handler              | The entry point for the function                                           |
| memory_size   | 128                        | Amount of memory allocated to the function in MB (128MB)                   |
| timeout       | 30                         | Maximum execution time allowed for the function in seconds                 |

1. Received event from **SES** and get email content from **S3**

```ts
// Helper function to extract email data from SES event
const extractEmailData = async (event: SESEvent) => {
  const sesRecord = event.Records[0].ses;
  const messageId = sesRecord.mail.messageId;
  const emailData = {
    sender: sesRecord.mail.source,
    key: messageId,
  };

  // Get email content from S3
  const getObjectCommand = new GetObjectCommand({
    Bucket: env.bucketName,
    Key: `received-email/${messageId}`
  });

  const response = await s3Client.send(getObjectCommand);
  const emailContent = await response.Body?.transformToString();

  // Parsing MIME type to JSON object
  const { text, subject } = await simpleParser(emailContent);
  return {
    ...emailData,
    subject,
    content: text || "No email data"
  };
};
```

2. Sending parsed content message to SQS

```ts
const body = await extractEmailData(event);
const command = new GetQueueUrlCommand({ // GetQueueUrlRequest
    QueueName: env.queueName, // required
});
const queueUrlResponse = await sqsClient.send(command);
const params = {
    QueueUrl: queueUrlResponse.QueueUrl,
    MessageBody: JSON.stringify(body),
};
await sqsClient.send(new SendMessageCommand(params));
```

Full source code
```ts
import { Handler, SESEvent } from 'aws-lambda';
import { GetQueueUrlCommand, SQSClient, SendMessageCommand } from "@aws-sdk/client-sqs";
import { GetObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { Logger } from '@aws-lambda-powertools/logger';
import * as mailparser from 'mailparser';

require('dotenv').config();

const simpleParser = mailparser.simpleParser;
const logger = new Logger();

const env = {
  queueName: process.env.QUEUE_NAME || "",
  bucketName: process.env.BUCKET_NAME || ""
}

const sqsClient = new SQSClient();
const s3Client = new S3Client();

// Helper function to extract email data from SES event
const extractEmailData = async (event: SESEvent) => {
  const sesRecord = event.Records[0].ses;
  const messageId = sesRecord.mail.messageId;
  const emailData = {
    sender: sesRecord.mail.source,
    key: messageId,
  };
  // logger.info("Email Data: ", JSON.stringify(emailData, null, 2));

  // Get email content from S3
  const getObjectCommand = new GetObjectCommand({
    Bucket: env.bucketName,
    Key: `received-email/${messageId}`
  });

  const response = await s3Client.send(getObjectCommand);
  const emailContent = await response.Body?.transformToString();
  const { text, subject } = await simpleParser(emailContent);
  return {
    ...emailData,
    subject,
    content: text || "No email data"
  };
};

export const handler: Handler = async (event: SESEvent): Promise<void> => {
  try {
    const body = await extractEmailData(event);
    // logger.info({
    //     message: "Extracted email data",
    //     body: body
    // });
    const command = new GetQueueUrlCommand({ // GetQueueUrlRequest
      QueueName: env.queueName, // required
    });
    const queueUrlResponse = await sqsClient.send(command);
    const params = {
      QueueUrl: queueUrlResponse.QueueUrl,
      MessageBody: JSON.stringify(body),
    };
    await sqsClient.send(new SendMessageCommand(params));
  }
  catch (error) {
    logger.error(error as string);
  }
};
```

#### Create SES rule for trigger extract email function

1. Go to SES dashboard and scroll down at the left panel **Configuration** > **Email receiving** > **Create rule set**

{{< img src="images/8.lambda/17a.png" title="lambda17a" >}}

2. Enter rule set name `TriggerEmailIncoming` and choose **Create rule set**

{{< img src="images/8.lambda/18a.png" title="lambda18a" >}}

3. Then choose **"Create rule"**

{{< img src="images/8.lambda/19.png" title="lambda19" >}}

4. We enter any name `ExtractAndSaveToS3` and choose **Next**

{{< img src="images/8.lambda/20.png" title="lambda20" >}}

5. At this step, as you can see, you can add many **Recipient conditions** look like the Guidelines, for simple i just want to trigger Lambda function and save email to S3. Then choose **Next**

{{< img src="images/8.lambda/21.png" title="lambda21" >}}

6. Choose **Add new action** > **Invoke AWS lambda function**

{{< img src="images/8.lambda/22.png" title="lambda22" >}}

7. Then we choose our function `ExtractEmailLambda` and add another action to save email to S3

{{< img src="images/8.lambda/23.png" title="lambda23" >}}

8. Next we need to choose existing S3 bucket and folder `received-email`. We also provide them a policy to allow SES put object to S3, choose **Create IAM Role**

{{< img src="images/8.lambda/24.png" title="lambda24" >}}

9. Enter our role name `SESSaveEmailToS3Role` and **Create role**

{{< img src="images/8.lambda/25.png" title="lambda25" >}}

10. We need to attach our policy we created from step 4.4, Choose **View role**

{{< img src="images/8.lambda/26.png" title="lambda26" >}}

11. Then we will attach our policy to this role. Choose **Attach policies**

{{< img src="images/8.lambda/27.png" title="lambda27" >}}

12. Please type `SESSaveEmailToS3Policy` from the search box > **SESSaveEmailToS3Policy** > **Add permissions**

{{< img src="images/8.lambda/28.png" title="lambda28" >}}

13. Attach success

{{< img src="images/8.lambda/29.png" title="lambda29" >}}

14.  Then we go back to SES, choose **Next**

{{< img src="images/8.lambda/30.png" title="lambda30" >}}

15. Choose **Create rule**

{{< img src="images/8.lambda/31.png" title="lambda31" >}}

16. Final, we need to active that rule, choose the rule and **Set as active**

{{< img src="images/8.lambda/32.png" title="lambda32" >}}

17. Confirm set that rule

{{< img src="images/8.lambda/33.png" title="lambda33" >}}

18. Setup receive email complete

{{< img src="images/8.lambda/34.png" title="lambda34" >}}
