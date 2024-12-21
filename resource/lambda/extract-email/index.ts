import { Handler, SESEvent } from 'aws-lambda';
import { GetQueueUrlCommand, SQSClient, SendMessageCommand } from "@aws-sdk/client-sqs";
import { GetObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { Logger } from '@aws-lambda-powertools/logger';
import * as mailparser from 'mailparser';

require('dotenv').config();
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
  
  // Parse to object
  const simpleParser = mailparser.simpleParser;
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
