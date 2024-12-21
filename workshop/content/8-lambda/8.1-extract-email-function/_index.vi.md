---
title : "Tạo Extract Email Function"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 8.1 </b> "
---

Đây là hàm đầu tiên, với các nhiệm vụ:

- Trích xuất nội dung email từ kiểu MIME thành dữ liệu JSON
- Gửi dữ liệu đó đến SQS.

#### Tại sao tôi cần hàm này?

Vì nhiều lý do:

- Tôi muốn tiết kiệm chi phí khi gọi Amazon Bedrock và Lambda function trong **Generate email** (Nếu email có dữ liệu sai, chúng ta có thể phân tích chúng thành dữ liệu đã định dạng trước khi gọi AI agent, giảm số lượng token gửi đến mô hình LLM)
- Dễ debug hơn
- Trong thực tế, có thể một số hater sẽ tấn công endpoint này bằng cách gửi thư rác, vì vậy chúng ta có thể đặt một hàm xử lý ở đây.

#### Các bước thực hiện

1. Ở **AWS Console**, tìm kiếm *"lambda"* và chọn **Lambda**

{{< img src="images/8.lambda/1.png" title="lambda1" >}}

2. Chọn **Create function**

{{< img src="images/8.lambda/2.png" title="lambda2" >}}

3. Ở mục **AWS Console**, chọn **Author from scratch**, Function name là `ExtractEmailLambda`, nodejs **Nodejs 22.x**. Chọn role đã tạo trước đó `ExtractEmailFunctionRole` và chọn **Create function**

{{< img src="images/8.lambda/3.png" title="lambda3" >}}

4. Tiếp, chúng ta cần upload source code cho function, bạn có thể download tại đây [index.zip](https://d9akteslg4v3w.cloudfront.net/workshops/002/extract/index.zip) hoặc bạn có thể tự build [tại đây](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies/tree/master/resource/lambda/extract-email). Sau khi tải về thì chọn **Code** > **Upload from** > **.zip file**

{{< img src="images/8.lambda/4.png" title="lambda4" >}}

5. Chọn **Save** để tải lên

{{< img src="images/8.lambda/5.png" title="lambda5" >}}

6. Upload thành công
{{< img src="images/8.lambda/6.png" title="lambda6" >}}

7. Tiếp theo, chúng ta cần thêm biến môi trường

{{< img src="images/8.lambda/7.png" title="lambda7" >}}

8. Chúng ta có 2 giá trị

| Key           | Value                              | Description                                                                                                                                           |
| ------------- | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `QUEUE_NAME`  | `sqs-generate-email-content-queue` | Queue này dùng để chứa email tới và gọi function tạo nội dung                                                                      |
| `BUCKET_NAME` | `ai-powered-email-auto-replies`    | Tên bucket để lấy nội dung email, vì SES không emit nội dung email mà chỉ emit key path (messageId) của email trên S3 |

Chọn **Save**

{{< img src="images/8.lambda/8.png" title="lambda8" >}}

9. Cập nhật thành công

{{< img src="images/8.lambda/9.png" title="lambda9" >}}

#### Thông tin chi tiết

| Configuration | Value                      | Description                                                                |
| ------------- | -------------------------- | -------------------------------------------------------------------------- |
| function_name | `ExtractEmailLambda`       | The unique name identifier for the Lambda function                         |
| role          | `ExtractEmailFunctionRole` | IAM role that defines the permissions and access policies for the function |
| runtime       | nodejs20.x                 | The execution environment and version for the Lambda function (Node.js 20) |
| handler       | index.handler              | The entry point for the function                                           |
| memory_size   | 128                        | Amount of memory allocated to the function in MB (128MB)                   |
| timeout       | 30                         | Maximum execution time allowed for the function in seconds                 |

1. Nhận event data từ **SES** và lấy dữ liệu từ **S3**

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

2. Gửi data qua message SQS

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

#### Tạo SES rule để trigger Extract Email function

1. Vào SES dashboard sau đó vào phần **Configuration** > **Email receiving** > **Create rule set**

{{< img src="images/8.lambda/17a.png" title="lambda17a" >}}

2. Thêm tên rule `TriggerEmailIncoming` và chọn **Create rule set**

{{< img src="images/8.lambda/18a.png" title="lambda18a" >}}

3. Chọn tiếp **"Create rule"**

{{< img src="images/8.lambda/19.png" title="lambda19" >}}

4. Nhập `ExtractAndSaveToS3` và chọn **Next**

{{< img src="images/8.lambda/20.png" title="lambda20" >}}

5. Như bạn có thể thấy **Recipient conditions** giống như Guidelines, để đơn giản thì tôi chỉ muốn trigger lambda function và lưu nội dung vào S3. Khi đó tôi chọn **Next**

{{< img src="images/8.lambda/21.png" title="lambda21" >}}

6. Chọn **Add new action** > **Invoke AWS lambda function**

{{< img src="images/8.lambda/22.png" title="lambda22" >}}

7. Chọn `ExtractEmailLambda` và thêm action khác là thêm vào S3

{{< img src="images/8.lambda/23.png" title="lambda23" >}}

8. Tiếp theo chúng ta chọn thư mục đã tạo `received-email`. Chúng ta cũng cần thêm policies để SES có thể thêm nội dung email vào S3, choose **Create IAM Role**

{{< img src="images/8.lambda/24.png" title="lambda24" >}}

9. Thêm role name `SESSaveEmailToS3Role` và **Create role**

{{< img src="images/8.lambda/25.png" title="lambda25" >}}

10. Chúng ta cần thêm vào policies đã tạo ở bước 4.4, chọn **View role**

{{< img src="images/8.lambda/26.png" title="lambda26" >}}

11. Chúng ta sẽ attach policies này vào. Chọn **Attach policies**

{{< img src="images/8.lambda/27.png" title="lambda27" >}}

12.  Tìm kiếm từ khoá `SESSaveEmailToS3Policy` > **SESSaveEmailToS3Policy** > **Add permissions**

{{< img src="images/8.lambda/28.png" title="lambda28" >}}

13. Attach thành công

{{< img src="images/8.lambda/29.png" title="lambda29" >}}

14. Chúng ta quay ngược lại SES và chọn **Next**

{{< img src="images/8.lambda/30.png" title="lambda30" >}}

15. Chọn **Create rule**

{{< img src="images/8.lambda/31.png" title="lambda31" >}}

16. Cuối cùng là active rule, chọn rule và chọn **Set as active**

{{< img src="images/8.lambda/32.png" title="lambda32" >}}

17. Xác nhận

{{< img src="images/8.lambda/33.png" title="lambda33" >}}

18. Cấu hình thành công

{{< img src="images/8.lambda/34.png" title="lambda34" >}}
