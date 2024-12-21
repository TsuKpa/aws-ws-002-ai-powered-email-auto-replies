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