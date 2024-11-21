import { emailFormatAgent } from './agents/email-format';
import { SQSEvent, Handler } from "aws-lambda";
import { GetQueueUrlCommand, SQSClient, SendMessageCommand } from "@aws-sdk/client-sqs";
import orchestrator from "./orchestrator";
import { Logger } from '@aws-lambda-powertools/logger';
import { env } from "./environment";
import { ConversationMessage } from 'multi-agent-orchestrator';

const logger = new Logger();
const sqs = new SQSClient();

type MessageData = {
  sender: string;
  key: string;
  subject: string;
  content: string;
}

export const handler: Handler = async (event: SQSEvent): Promise<any> => {
  const record = event.Records[0];
  try {
    const eventData: MessageData = JSON.parse(record.body);
    logger.info("Event Data: ", record.body);
    const response = await orchestrator.routeRequest(
      eventData.content,
      "userId",
      "sessionId"
    );

    const finalResponse = await emailFormatAgent.processRequest(response.output as string, "user", "session", []) as ConversationMessage;

    logger.info("Final Response: ", finalResponse.content as unknown as string);

    const command = new GetQueueUrlCommand({ // GetQueueUrlRequest
      QueueName: env.RESPONSE_QUEUE_NAME, // required
    });
    const queueUrlResponse = await sqs.send(command);
    const sendMessageCommand = new SendMessageCommand({
      QueueUrl: queueUrlResponse.QueueUrl,
      MessageBody: JSON.stringify({
        messageId: eventData.key,
        sender: eventData.sender,
        subject: `Re: ${eventData.subject}`,
        text: finalResponse.content ? finalResponse.content[0].text : "Sorry, I couldn't generate a response for your email."
      }),
    });
    await sqs.send(sendMessageCommand);
    return {
      statusCode: 200,
      body: "Success"
    }
  } catch (error) {
    logger.error("Error when processing data:", error);
  }
};
